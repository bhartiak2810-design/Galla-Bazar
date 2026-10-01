package in.nutrigrain.gallabazar;

import android.Manifest;
import android.app.Activity;
import android.content.Intent;
import android.content.pm.PackageManager;
import android.net.Uri;
import android.os.Bundle;
import android.webkit.GeolocationPermissions;
import android.webkit.WebChromeClient;
import android.webkit.WebSettings;
import android.webkit.WebView;
import android.webkit.WebViewClient;
import android.widget.Toast;

public class MainActivity extends Activity {
  private static final int REQ_LOC=11;
  private WebView web;
  private GeolocationPermissions.Callback geoCb;
  private String geoOrigin;

  @Override public void onCreate(Bundle b){
    super.onCreate(b);
    web=new WebView(this);
    setContentView(web);
    WebSettings s=web.getSettings();
    s.setJavaScriptEnabled(true);
    s.setDomStorageEnabled(true);
    s.setGeolocationEnabled(true);
    s.setAllowFileAccess(true);
    web.setWebViewClient(new WebViewClient(){
      @Override public boolean shouldOverrideUrlLoading(WebView v,String url){
        if(url.startsWith("file:")) return false;
        try{startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(url)));}catch(Exception e){Toast.makeText(MainActivity.this,"Link open nahi ho paya",Toast.LENGTH_SHORT).show();}
        return true;
      }
    });
    web.setWebChromeClient(new WebChromeClient(){
      @Override public void onGeolocationPermissionsShowPrompt(String origin, GeolocationPermissions.Callback cb){
        if(checkSelfPermission(Manifest.permission.ACCESS_FINE_LOCATION)==PackageManager.PERMISSION_GRANTED) cb.invoke(origin,true,false);
        else { geoCb=cb; geoOrigin=origin; requestPermissions(new String[]{Manifest.permission.ACCESS_FINE_LOCATION,Manifest.permission.ACCESS_COARSE_LOCATION},REQ_LOC); }
      }
    });
    web.loadUrl("file:///android_asset/index.html");
  }

  @Override public void onRequestPermissionsResult(int requestCode,String[] permissions,int[] grantResults){
    super.onRequestPermissionsResult(requestCode,permissions,grantResults);
    if(requestCode==REQ_LOC && geoCb!=null){
      boolean ok=grantResults.length>0 && grantResults[0]==PackageManager.PERMISSION_GRANTED;
      geoCb.invoke(geoOrigin,ok,false); geoCb=null; geoOrigin=null;
    }
  }

  @Override public void onBackPressed(){ if(web.canGoBack()) web.goBack(); else super.onBackPressed(); }
}
