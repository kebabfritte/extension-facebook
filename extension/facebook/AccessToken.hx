package extension.facebook;
import openfl.utils.JNI;

/**
 * ...
 * @author Thomas B
 */
class AccessToken
{
	
	static var mCurrentToken : Dynamic;
	
	public static function getCurrent() : AccessToken {
		
		if (mCurrentToken == null)
			mCurrentToken = new AccessToken(null);
		
		#if android
		var token = jni_getCurrentToken();
		if (token != null && token != mCurrentToken) {
			mCurrentToken = token;
			return new AccessToken(token);
		}
		else if (token == mCurrentToken)
			return mCurrentToken;
		else
			return new AccessToken(null);
		#end
		
		return null;
	}
	
	var mToken : Dynamic;

	function new(token : Dynamic) 
	{
		mToken = token;
	}
	
	public function isExpired() : Bool {
		
		if (mToken == null)
			return true;
		
		#if android
		return JNI.callMember(jni_isExpired, mToken, []);
		#end
		return true;
	}
	
	public function getPermissions() : Array<String>{
		
		if (mToken == null)
			return [];
		
		#if android
		var permissions : String = jni_getPermissions(mToken);
		return permissions.split(",");
		#end
		
		return [];
	}
	
	public function getDeclinedPermissions() : Array<String>{
		if (mToken == null)
			return [];
		
		#if android
		var permissions : String = jni_getPermissions(mToken);
		return permissions.split(",");
		#end
		
		return [];
	}
	
	public function hasPermissions(permissions : Array<String>) : Bool {
		var perms = getPermissions();
		
		for (perm in permissions) 
			if (perms.indexOf(perm) == -1)
				return false;
		return true;
	}
	
	public function getUserId() : String {
		
		if (mToken == null) return null;
		
		#if android
		return JNI.callMember(jni_getUserId, mToken, []);
		#end
		
		return null;
	}
	
	public function getToken() : String {
		if (mToken == null) return null;
		
		#if android
		return JNI.callMember(jni_getToken, mToken, []);
		#end
		
		return null;
	}
	
	#if android
	static var jni_getCurrentToken : Dynamic = JNI.createStaticMethod("com.facebook.AccessToken", "getCurrentAccessToken", "()Lcom/facebook/AccessToken;");
	
	static var jni_getPermissions : Dynamic = JNI.createStaticMethod("org.haxe.extension.facebook.AccessTokenWrapper", "getPermissions", "(Lcom/facebook/AccessToken;)Ljava/lang/String;");
	static var jni_getDeclinedPermissions : Dynamic = JNI.createStaticMethod("org.haxe.extension.facebook.AccessTokenWrapper", "getDeclinedPermissions", "(Lcom/facebook/AccessToken;)Ljava/lang/String;");
	
	static var jni_isExpired : Dynamic =  JNI.createMemberMethod("com.facebook.AccessToken", "isExpired", "()Z");
	static var jni_getUserId : Dynamic = JNI.createMemberMethod("com.facebook.AccessToken", "getUserId", "()Ljava/lang/String;");
	static var jni_getToken : Dynamic = JNI.createMemberMethod("com.facebook.AccessToken", "getToken", "()Ljava/lang/String;");
	
	#end
	
}