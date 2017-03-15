Class FAQ.FAQTopicQuery Extends %ZEN.Mojo.basePage
{

Parameter ALLOWMOBILE = 1;

/// Class name of application this page belongs to.
Parameter APPLICATION = "";

/// Displayed name of this page.
Parameter PAGENAME = "HomePage";

/// Domain used for localization.
Parameter DOMAIN = "Zen Mojo FAQ";

/// List of JSON providers created for this page.
/// Used by contentProvider.
Parameter PROVIDERLIST = "data,layout";

/// Starting template class for this page
/// Used by contentProvider.
/// This is overriden by application settings, of provided.
Parameter TEMPLATECLASS = "FAQ.FAQTopicQueryTemplate";

/// Comma-separated list of additional CSS3 include files for the page.
/// If this is defined *and* this page is using CSS3, then the CSSINCLUDES parameter is ignored.
/// If this is not defined *and* this page is using CSS3, then the CSSINCLUDES parameter is used.
Parameter CSSINCLUDES As STRING = "jquery.mobile-1.3.2.min.css";

/// Comma-separated list of additional JS include files for the page.
Parameter JSINCLUDES As STRING = "jquery-1.10.2.min.js,jquery.mobile-1.3.2.min.js";

/// This Style block contains page-specific CSS style definitions.
XData Style
{
<style type="text/css">
	.ui-listview-filter {
		margin: 0px;
	}
	pre {
		font-size: 100%;
	}
    div.divcommand
    {
      width:90%;
      overflow-x:auto;
      margin:10px 0px;
      background-color:#E0FFFF;
    }
	
</style>
}

/// This XML block defines the contents of this pane.
XData pageContents [ XMLNamespace = "http://www.intersystems.com/zen" ]
{
<pane xmlns="http://www.intersystems.com/zen"
xmlns:mojo="http://www.intersystems.com/zen/mojo"
layout="none">

<mojo:documentView id="mainView" enclosingStyle=""
developerMode="false" 
onload="zenPage._latestjQMVersion = 'jQM-1.3.2-Helper';"
initialDocumentKey="query-entry"
initialLayoutKey="query-entry"
ongetlayout = "return zenPage.getContent('layout',key,criteria);"
ongetdata = "return zenPage.getContent('data',key,criteria);"
>
<mojo:jQM-1.3.2-PageManager jQueryAnimation="slide" onPageShow="zenPage.onPageShow(layoutkey,documentkey);">
<mojo:jQM-1.3.2-Helper/>
<mojo:HTML5Helper/>
<mojo:mojoDefaultHelper/>
</mojo:jQM-1.3.2-PageManager>
</mojo:documentView>

</pane>
}

ClientMethod onPageShow(layoutkey, documentkey) [ Language = javascript ]
{
	// dispatch to template object
	var template = this.getTemplate();
	return (template&&template.pageShow) ? template.pageShow(layoutkey, documentkey) : null;
}

/// Implementation for this page. This method adjusts the size of components 
/// within the content area based on the current width and height of the screen. 
/// In this case there is only one component.
ClientMethod adjustContentSize(load, width, height) [ Language = javascript ]
{
	
	var mainView = zen('mainView');
	if (mainView) {
		var mainDiv = mainView.getEnclosingDiv();
		mainDiv.style.top =  '0px';
		mainDiv.style.left = '0px';
	}
}

Method %OnDrawHTMLMeta() As %Status
{
	 Write "<meta name=""viewport"" content=""width=device-width,initial-scale=1.0""/>"
	 Quit $$$OK
}

}
