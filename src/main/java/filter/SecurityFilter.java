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
// @WebFilter("/*")
public class SecurityFilter implements Filter{
	//로그인 없이 접근 가능한 경로 목록
	Set<String> whiteList = Set.of(
		"/index.jsp", "/userp/signuppath.jsp",
		"/userp/signup-form.jsp", "/userp/signup.jsp",
		"/userp/hqlogin-form.jsp", "/userp/hqlogin.jsp",
		"/userp/branchlogin-form.jsp", "/userp/branchlogin.jsp",
		"/images/", "/userp/loginform.jsp"
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
		String cPath=req.getContextPath(); // "/Step02DataBase"
		//클라이언트의 요청경로 얻어내기(context path가 포함되어 있음)
		String uri=req.getRequestURI(); // "/Step02DataBase/index.jsp"
		//uri 에서 context path 를 제거한 순수 경로를 얻어낸다
		String path=uri.substring(cPath.length()); // "/index.jsp"
				
		//로그인 없이 접근 가능한 요청 경로면 필터링을 하지 않는다
		// if(isWhiteList(path)) {
		if(true) {
			chain.doFilter(request, response);
			return; //메소드를 여기서 종료하기
		}
		
		//로그인 여부 확인
		String userId=(String)session.getAttribute("userId");
		//role 정보 얻어오기
		String role=(String)session.getAttribute("role");
		
		//만일 로그인을 하지 않았다면 
		if(userId == null) {
			//로그인 페이지로 리다이렉트(새로운 경로로 요청을 다시하라고 응답) 이동 시킨다 
			//query 문자열이 있으면 읽어와서 
	        String query = req.getQueryString();
	        //인코딩을 한다음 
	        String encodedUrl = query == null ? URLEncoder.encode(uri, "UTF-8")
	                                          : URLEncoder.encode(uri + "?" + query, "UTF-8");
	        //리다이렉트 되는 경로뒤에 url 이라는 파라미터명으로 전달한다 
	        res.sendRedirect(req.getContextPath() + "/userp/loginform.jsp?url=" + encodedUrl); 
			return; //메소드를 여기서 끝내기
		}
		
		//권한 체크
		//만일 isAuthorized() 메소드가 false 를 리턴한다면 (접근 불가하다고 판정이 된다면)
		if(!isAuthorized(path, role)) {
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
        if ("ROLE_KING".equals(role)) {
            return true; // 모든 경로 접근 허용
        } else if ("ROLE_ADMIN".equals(role)) {
        	// "/index/branchindex.jsp" 하위 경로를 제외한 모든 경로 접근 허용
            return !path.startsWith("/index/branchindex.jsp");
        } else if ("ROLE_MANAGER".equals(role)) {
        	// "/index/headqueaterindex.jsp" 하위 경로를 제외한 모든 경로 접근 허용
            return !path.startsWith("/index/headquaterindex.jsp");
        } else if ("ROLE_CLERK".equals(role)) {
        	// "/index/headquaterindex.jsp" 하위 경로를 제외한 모든 경로 접근 허용
            return !path.startsWith("/index/headquaterindex.jsp");
        } else if ("ROLE_UNAPPROVED".equals(role)) {
        	// "/index/" 하위를 제외한 모든 경로 접근 허용
            return !path.startsWith("/index/");
        }
        return false; // unknown role
    }
}
