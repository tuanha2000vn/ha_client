part of '../main.dart';

class Launcher {

  static void launchURL(String url) async {
    if (await urlLauncher.canLaunch(url)) {
      await urlLauncher.launch(url);
    } else {
      Logger.e( "Could not launch $url");
    }
  }

  static void launchAuthenticatedWebView({BuildContext context, String url, String title}) {
    if (url.contains("?")) {
      url += "&external_auth=1";
    } else {
      url += "?external_auth=1";
    }
    final flutterWebViewPlugin = new FlutterWebviewPlugin();
    flutterWebViewPlugin.onStateChanged.listen((viewState) async {
      if (viewState.type == WebViewState.startLoad) {
        Logger.d("[WebView] Injecting external auth JS");
        rootBundle.loadString('assets/js/externalAuth.js').then((js){
          flutterWebViewPlugin.evalJavascript(js.replaceFirst("[token]", ConnectionManager()._token));
        });
      }
    });
    Navigator.of(context).pushNamed(
        "/webview",
        arguments: {
          "url": "$url",
          "title": "${title ?? ''}"
        }
    );
  }

  static void launchURLInCustomTab({BuildContext context, String url, bool enableDefaultShare: true, bool showPageTitle: true}) async {
    try {
      await launch(
        "$url",
        option: new CustomTabsOption(
          toolbarColor: Theme.of(context).primaryColor,
          enableDefaultShare: enableDefaultShare,
          enableUrlBarHiding: true,
          showPageTitle: showPageTitle,
          animation: new CustomTabsAnimation.slideIn()
          // or user defined animation.
          /*animation: new CustomTabsAnimation(
          startEnter: 'slide_up',
          startExit: 'android:anim/fade_out',
          endEnter: 'android:anim/fade_in',
          endExit: 'slide_down',
        )*/,
          extraCustomTabs: <String>[
            // ref. https://play.google.com/store/apps/details?id=org.mozilla.firefox
            'org.mozilla.firefox',
            // ref. https://play.google.com/store/apps/details?id=com.microsoft.emmx
            'com.microsoft.emmx',
          ],
        ),
      );
    } catch (e) {
      Logger.w("Can't open custom tab: ${e.toString()}");
      Logger.w("Launching in default browser");
      Launcher.launchURL(url);
    }
  }

}