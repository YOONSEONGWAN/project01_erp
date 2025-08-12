package filter;

import java.io.IOException;
import java.net.URLEncoder;
import java.util.Set;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

//들어오는 모든 요청에 대해서 필터링을 하겠다는 의미
@WebFilter("/*")	
public class SecurityFilter implements Filter{
	//로그인 없이 접근 가능한 경로 목록
	Set<String> whiteList = Set.of(
		"/index.jsp", "/userp/signuppath.jsp",
		"/userp/signup-form.jsp", "/userp/signup.jsp",
		"/userp/hqlogin-form.jsp", "/userp/hqlogin.jsp",
		"/userp/branchlogin-form.jsp", "/userp/branchlogin.jsp",
		"/images/", "/userp/loginform.jsp", "/board/file-download"
	);
	
	@Override
	public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
			throws IOException, ServletException {
		//로그인을 했는지 확인작업
		//부모 type 을 자식 type 으로 casting
		HttpServletRequest req=(HttpServletRequest)request; //req.getContextPath 메소드 사용하기 위해
		HttpServletResponse res=(HttpServletResponse)response;//res.sendRedirect 메소드 사용하기 위해
		//HttpSession 객체의 참조값 얻어내기
		HttpSession session=req.getSession();
		//context path
		String cPath=req.getContextPath(); // 예: "/project01_erp"
		//클라이언트의 요청경로 얻어내기(context path가 포함되어 있음)
		String uri=req.getRequestURI(); // 예: "/project01_erp/index.jsp"
		//uri 에서 context path 를 제거한 순수 경로를 얻어낸다
		String path=uri.substring(cPath.length()); // 예: "/index.jsp"
				
		//로그인 없이 접근 가능한 요청 경로면 필터링을 하지 않는다
		if(isWhiteList(path)) {
			chain.doFilter(request, response);
			return; //메소드를 여기서 종료하기
		}
		
		//로그인 여부 확인
		String userId=(String)session.getAttribute("userId");
		//role 정보 얻어오기
		String role=(String)session.getAttribute("role");

        if (userId == null) {
            // 원래 가려던 URL을 보존해서 로그인 후 복귀
            String query = req.getQueryString();
            String backUrl = (query == null) ? uri : (uri + "?" + query);
            String encodedUrl = URLEncoder.encode(backUrl, "UTF-8");
            res.sendRedirect(req.getContextPath() + "/userp/loginform.jsp?url=" + encodedUrl);
            return;
        }

        // headquater.jsp?page=... 같은 내부 include 경로까지 반영
        String page = req.getParameter("page");
        String effectivePath = path; // 기본은 실제 요청 path
        if (page != null && !page.isBlank()) {
            // 앞에 슬래시 보정
            effectivePath = page.startsWith("/") ? page : "/" + page;
        }

		
		//권한 체크
		//만일 isAuthorized() 메소드가 false 를 리턴한다면 (접근 불가하다고 판정이 된다면)
		if(!isAuthorized(effectivePath, role)) {
			//금지된 요청이라고 응답하고
			res.sendError(HttpServletResponse.SC_FORBIDDEN, "접근 권한이 없습니다");
			return; //메소드를 여기서 끝낸다
		}
		
		chain.doFilter(request, response);
	}
	
    // 화이트리스트 검사
    private boolean isWhiteList(String path) {
    	//만일 최상위 경로 요청이면 허용
        if ("/".equals(path)) return true;  

        //반복문 돌면서 모든 whiteList 를 불러내서
        for (String prefix : whiteList) {
        	//현재 요청경로와 대조한다
            if (path.startsWith(prefix)) {
                return true;
            }
        }
        return false;
    }

    
    
    // 역할 기반 권한 검사
    // 클라이언트 요청경로와 role 정보를 넣어서 접근 가능한지 여부를 리턴하는 메소드
    private boolean isAuthorized(String path, String role) {
        if ("king".equals(role)) {
            return true; // 모든 경로 접근 허용
        } else if ("admin".equals(role)) {
        	// "/index/branchindex.jsp" 하위와 "/hrm/" 경로를 제외한 모든 경로 접근 허용
            return !path.startsWith("/index/branch.jsp") && !path.startsWith("/hrm/");
        } else if ("manager".equals(role)) {
        	// "/index/headqueaterindex.jsp" 하위 경로를 제외한 모든 경로 접근 허용
            return !path.startsWith("/index/headquater.jsp") && !path.startsWith("/branch-admin/");
        } else if ("clerk".equals(role)) {
        	// "/index/headquaterindex.jsp" 하위 경로를 제외한 모든 경로 접근 허용
            return !path.startsWith("/index/headquater.jsp");
        } else if ("unapproved".equals(role)) {
        	// "/index/" 하위를 제외한 모든 경로 접근 허용
            return !path.startsWith("/index/");
        }
        return false; // unknown role
    }
}