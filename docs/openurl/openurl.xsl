<?xml version="1.0" encoding="UTF-8"?>
<!-- Edited with emacs -->
<!-- New Namespace -->
<xsl:stylesheet version="1.0" xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
                xml:base="http://alcme.oclc.org/"
                xmlns:dt="urn:schemas-microsoft-com:datatypes"
                xmlns:d2="uuid:C2F41010-65B3-11d1-A29F-00AA00C14882"
                xmlns:str="http://xsltsl.org/string"
                xmlns:oai="http://www.openarchives.org/OAI/2.0/"
                xmlns:oai_id="http://www.openarchives.org/OAI/2.0/oai-identifier"
                xmlns:oai_branding="http://www.openarchives.org/OAI/2.0/branding/"
                xmlns:oai_dc="http://www.openarchives.org/OAI/2.0/oai_dc/"
                xmlns:dc="http://purl.org/dc/elements/1.1/"
                xmlns:provenance="http://www.openarchives.org/OAI/2.0/provenance"
                xmlns:toolkit="http://oai.dlib.vt.edu/OAI/metadata/toolkit">
    <!--
      <xsl:import href="/openurl/string.xsl"/>
    -->
    <xsl:output method="html" version="4.0" standalone="yes" indent="yes"
                doctype-public="-//W3C//DTD HTML 4.01 Transitional//EN"
                doctype-system="http://www.w3.org/TR/html4/loose.dtd"
                encoding="UTF-8" />

    <xsl:key name="setSpecs" match="/oai:OAI-PMH/oai:ListIdentifiers/oai:header/oai:setSpec" use="."/>

    <xsl:template match="/oai:OAI-PMH">
        <html>
            <head>
                <title><xsl:choose>
                    <xsl:when test="oai:Identify"><xsl:value-of select="oai:Identify/oai:repositoryName"/></xsl:when>
                    <xsl:when test="oai:GetRecord">
                        <xsl:variable name="temp">
                            <xsl:call-template name="replace-substring">
                                <xsl:with-param name="value" select="oai:GetRecord/oai:record/oai:header/oai:setSpec" />
                                <xsl:with-param name="from"><xsl:text>+</xsl:text></xsl:with-param>
                                <xsl:with-param name="to"><xsl:text> </xsl:text></xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="replace-substring">
                            <xsl:with-param name="value" select="$temp" />
                            <xsl:with-param name="from"><xsl:text>%3A</xsl:text></xsl:with-param>
                            <xsl:with-param name="to"><xsl:text>:</xsl:text></xsl:with-param>
                        </xsl:call-template>
                        <xsl:text> - </xsl:text><xsl:value-of select="oai:GetRecord/oai:record/oai:header/oai:identifier"/>
                    </xsl:when>
                    <xsl:when test="oai:ListRecords">
                        <xsl:variable name="temp">
                            <xsl:call-template name="replace-substring">
                                <xsl:with-param name="value" select="oai:request/@set" />
                                <xsl:with-param name="from"><xsl:text>+</xsl:text></xsl:with-param>
                                <xsl:with-param name="to"><xsl:text> </xsl:text></xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="replace-substring">
                            <xsl:with-param name="value" select="$temp" />
                            <xsl:with-param name="from"><xsl:text>%3A</xsl:text></xsl:with-param>
                            <xsl:with-param name="to"><xsl:text>:</xsl:text></xsl:with-param>
                        </xsl:call-template>
                    </xsl:when>
                    <xsl:when test="oai:request/@identifier"><xsl:value-of select="oai:request/@identifier"/></xsl:when>
                    <xsl:otherwise>OpenURL Framework Repository</xsl:otherwise>
                </xsl:choose></title>
                <STYLE>
                    BODY {font:small 'Verdana'; margin-right:1.5em}
                    <!-- container for expanding/collapsing content -->
                    .c  {cursor:hand}
                    <!-- button - contains +/-/nbsp -->
                    .b  {color:red; font-family:'Courier New'; font-weight:bold; text-decoration:none}
                    <!-- element container -->
                    .e  {margin-left:1em; text-indent:-1em; margin-right:1em}
                    <!-- comment or cdata -->
                    .k  {margin-left:1em; text-indent:-1em; margin-right:1em}
                    <!-- tag -->
                    .t  {color:#990000}
                    <!-- tag in xsl namespace -->
                    .xt {color:#990099}
                    <!-- attribute in xml or xmlns namespace -->
                    .ns {color:red}
                    <!-- attribute in dt namespace -->
                    .dt {color:green}
                    <!-- markup characters -->
                    .m  {color:blue}
                    <!-- text node -->
                    .tx {font-weight:bold}
                    <!-- multi-line (block) cdata -->
                    .db {text-indent:0px; margin-left:1em; margin-top:0px; margin-bottom:0px;
                    padding-left:.3em; border-left:1px solid #CCCCCC; font:small Courier}
                    <!-- single-line (inline) cdata -->
                    .di {font:small Courier}
                    <!-- DOCTYPE declaration -->
                    .d  {color:blue}
                    <!-- pi -->
                    .pi {color:blue}
                    <!-- multi-line (block) comment -->
                    .cb {text-indent:0px; margin-left:1em; margin-top:0px; margin-bottom:0px;
                    padding-left:.3em; font:small Courier; color:#888888}
                    <!-- single-line (inline) comment -->
                    .ci {font:small Courier; color:#888888}
                    PRE {margin:0px; display:inline}
                </STYLE>

                <SCRIPT><xsl:comment><![CDATA[
        // Detect and switch the display of CDATA and comments from an inline view
        //  to a block view if the comment or CDATA is multi-line.
        function f(e)
        {
          // if this element is an inline comment, and contains more than a single
          //  line, turn it into a block comment.
          if (e.className == "ci") {
            if (e.children(0).innerText.indexOf("\n") > 0)
              fix(e, "cb");
          }

          // if this element is an inline cdata, and contains more than a single
          //  line, turn it into a block cdata.
          if (e.className == "di") {
            if (e.children(0).innerText.indexOf("\n") > 0)
              fix(e, "db");
          }

          // remove the id since we only used it for cleanup
          e.id = "";
        }

        // Fix up the element as a "block" display and enable expand/collapse on it
        function fix(e, cl)
        {
          // change the class name and display value
          e.className = cl;
          e.style.display = "block";

          // mark the comment or cdata display as a expandable container
          j = e.parentElement.children(0);
          j.className = "c";

          // find the +/- symbol and make it visible - the dummy link enables tabbing
          k = j.children(0);
          k.style.visibility = "visible";
          k.href = "#";
        }

        // Change the +/- symbol and hide the children.  This function works on "element"
        //  displays
        function ch(e)
        {
          // find the +/- symbol
          mark = e.children(0).children(0);

          // if it is already collapsed, expand it by showing the children
          if (mark.innerText == "+")
          {
            mark.innerText = "-";
            for (var i = 1; i < e.children.length; i++)
              e.children(i).style.display = "block";
          }

          // if it is expanded, collapse it by hiding the children
          else if (mark.innerText == "-")
          {
            mark.innerText = "+";
            for (var i = 1; i < e.children.length; i++)
              e.children(i).style.display="none";
          }
        }

        // Change the +/- symbol and hide the children.  This function work on "comment"
        //  and "cdata" displays
        function ch2(e)
        {
          // find the +/- symbol, and the "PRE" element that contains the content
          mark = e.children(0).children(0);
          contents = e.children(1);

          // if it is already collapsed, expand it by showing the children
          if (mark.innerText == "+")
          {
            mark.innerText = "-";
            // restore the correct "block"/"inline" display type to the PRE
            if (contents.className == "db" || contents.className == "cb")
              contents.style.display = "block";
            else contents.style.display = "inline";
          }

          // if it is expanded, collapse it by hiding the children
          else if (mark.innerText == "-")
          {
            mark.innerText = "+";
            contents.style.display = "none";
          }
        }

        // Handle a mouse click
        function cl()
        {
          e = window.event.srcElement;

          // make sure we are handling clicks upon expandable container elements
          if (e.className != "c")
          {
            e = e.parentElement;
            if (e.className != "c")
            {
              return;
            }
          }
          e = e.parentElement;

          // call the correct funtion to change the collapse/expand state and display
          if (e.className == "e")
            ch(e);
          if (e.className == "k")
            ch2(e);
        }

        // Dummy function for expand/collapse link navigation - trap onclick events instead
        function ex()
        {}

        // Erase bogus link info from the status window
        function h()
        {
          window.status=" ";
        }

        // Set the onclick handler
        document.onclick = cl;

      ]]></xsl:comment></SCRIPT>
                <style type="text/css">
                    <xsl:comment>
                        ADDRESS {
                        FONT-SIZE: small; FONT-FAMILY: Geneva, Verdana, Helvetica, Arial, sans-serif
                        }
                        BODY {
                        FONT-SIZE: small; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, Geneva, Verdana, sans-serif
                        }
                        BUTTON {
                        CURSOR: auto
                        }
                        H2 {
                        FONT: bold 18px helvetica, arial, sans-serif; COLOR: #00527c
                        }
                        HR {
                        COLOR: #cccccc; HEIGHT: 1px
                        }
                        INPUT {
                        CURSOR: auto; COLOR: #000000
                        }
                        SELECT {
                        FONT-SIZE: small; COLOR: #000000; FONT-FAMILY: Arial, Helvetica, Geneva, Verdana, sans-serif
                        }
                        TD {
                        FONT-SIZE: small; MARGIN-LEFT: 0px; FONT-FAMILY: Arial, Helvetica, Geneva, Verdana, sans-serif
                        }
                        TEXTAREA {
                        CURSOR: text; COLOR: #000000; BACKGROUND-COLOR: #ffffff
                        }
                        TH {
                        FONT-WEIGHT: bold; FONT-SIZE: small; MARGIN-LEFT: 0px; FONT-FAMILY: Arial, Helvetica, Geneva, Verdana, sans-serif; TEXT-ALIGN: center
                        }
                        A.footer:link {
                        COLOR: #336600; TEXT-DECORATION: none
                        }
                        A.footer:link {
                        COLOR: #336600; TEXT-DECORATION: none
                        }
                        A.footer:visited {
                        COLOR: #669933; TEXT-DECORATION: none
                        }
                        A.footer:active {
                        COLOR: #99cc33; TEXT-DECORATION: none
                        }
                        A.footer:hover {
                        COLOR: #ff0000; TEXT-DECORATION: underline
                        }
                        .divider {
                        COLOR: #999999
                        }
                        .nospace {
                        MARGIN-TOP: 0px; MARGIN-BOTTOM: 0px
                        }
                    </xsl:comment>
                </style>
            </head>
            <body leftmargin="0" topmargin="0" marginwidth="0" marginheight="0">
                <table width="100%" border="0" cellpadding="0" cellspacing="20">
                    <tr valign="top">
                        <td>
                            <table width="100%" border="0" cellspacing="0" cellpadding="0">
                                <tr valign="TOP">
                                    <td><a href="http://www.niso.org/"><img src="http://www.niso.org/images/headermain/logo.png" border="0" alt="NISO"/></a><br/><img src="http://www.niso.org/design/images/spacer.gif" width="25" height="25" alt=""/></td>
                                    <td colspan="3"><h1>Registry for the OpenURL Framework - ANSI/NISO Z39.88-2004</h1></td>
                                    <!--
                                                      <td><a href="http://www.niso.org"><img src="http://www.niso.org/design/images/home_niso_logo.gif" width="140" height="54" alt="NISO"/></a><br/><img src="http://www.niso.org/design/images/spacer.gif" width="25" height="25" alt=""/></td>
                                                      <td colspan="3"><img src="http://www.niso.org/design/images/home_niso_title.gif" width="384" height="40" alt="National Information Standards Organzation"/></td>
                                    -->
                                </tr>
                            </table>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td><a href="/OpenURL-Frozen/Identify.xml">Repository Identification</a><xsl:text disable-output-escaping="yes">&#160;</xsl:text><span class="divider">|</span><xsl:text disable-output-escaping="yes">&#160;</xsl:text><a href="/OpenURL-Frozen/ListSets.xml">Registry Entries</a><xsl:text disable-output-escaping="yes">&#160;</xsl:text><span class="divider">|</span><xsl:text disable-output-escaping="yes">&#160;</xsl:text><a href="/OpenURL-Frozen/docs/pdf/SubmittalProcess.pdf">Submittal Process</a><xsl:text disable-output-escaping="yes">&#160;</xsl:text><span class="divider">|</span><xsl:text disable-output-escaping="yes">&#160;</xsl:text><a href="/OpenURL-Frozen/docs/implementation_guidelines/">Implementation Guidelines</a><xsl:text disable-output-escaping="yes">&#160;</xsl:text><span class="divider">|</span><xsl:text disable-output-escaping="yes">&#160;</xsl:text><a href="/OpenURL-Frozen/docs/pdf/openurl-01.pdf">NISO OpenURL Version 0.1</a><xsl:text disable-output-escaping="yes">&#160;</xsl:text><span class="divider">|</span><xsl:text disable-output-escaping="yes">&#160;</xsl:text><a href="http://alcme.oclc.org/openurl/servlet/OAIHandler/extension?verb=GetMetadata&amp;metadataPrefix=xsd&amp;identifier=info:ofi/fmt:xml:xsd:pro-2004">Community Profile XML Format</a><xsl:text disable-output-escaping="yes">&#160;</xsl:text><span class="divider">|</span><xsl:text disable-output-escaping="yes">&#160;</xsl:text><a href="http://alcme.oclc.org/openurl/notes.html">Notes</a></td>
                    </tr>
                    <tr valign="top">
                        <td bgcolor="#cccccc">
                            <table width="100%" border="0" cellpadding="4" cellspacing="0">
                                <xsl:apply-templates select="oai:responseDate|oai:request"/>
                            </table>
                        </td>
                    </tr>
                    <tr valign="top">
                        <td><xsl:apply-templates select="oai:Identify|oai:GetRecord|oai:ListIdentifiers|oai:ListMetadataFormats|oai:ListRecords|oai:ListSets|oai:error"/></td>
                    </tr>
                    <tr valign="top">
                        <td bgcolor="#F9DD50" height="10"></td>
                    </tr>
                    <tr valign="top">
                        <td><a href="http://www.oclc.org/research/software/oai/cat.shtm"><img border="0" src="http://alcme.oclc.org/openurl/oaicat_icon.gif" alt="OAICat - An OAI-PMH v2 Repository Framework" width="120" height="60"/></a>&#160;&#160;&#160;&#160;<a href="http://www.openarchives.org"><img border="0" src="/openurl/OA100.gif"/></a></td>
                    </tr>
                    <tr valign="top">
                        <td><address><a href="mailto:openurlagency@oclc.org?subject=OpenURL Registry Comment">openurlagency@oclc.org</a></address></td>
                    </tr>
                </table>
            </body>
        </html>
    </xsl:template>

    <xsl:template match="oai:Identify">
        <h2 align="center"><xsl:value-of select="oai:repositoryName"/><br/>An <a href="http://www.openarchives.org/">OAI-PMH <xsl:value-of select="oai:protocolVersion"/></a> Repository</h2>
        <table width="100%" border="1" cellspacing="2" cellpadding="0">
            <tr><th colspan="2">OAI Identify Response</th></tr>
            <xsl:apply-templates/>
        </table>

    </xsl:template>

    <xsl:template match="oai:GetRecord">
        <h2>
            <!--
                  <xsl:value-of select="*/oai:header/oai:setSpec"/>
            -->
            <xsl:variable name="temp">
                <xsl:call-template name="replace-substring">
                    <xsl:with-param name="value" select="*/oai:header/oai:setSpec" />
                    <xsl:with-param name="from"><xsl:text>+</xsl:text></xsl:with-param>
                    <xsl:with-param name="to"><xsl:text> </xsl:text></xsl:with-param>
                </xsl:call-template>
            </xsl:variable>
            <xsl:call-template name="replace-substring">
                <xsl:with-param name="value" select="$temp" />
                <xsl:with-param name="from"><xsl:text>%3A</xsl:text></xsl:with-param>
                <xsl:with-param name="to"><xsl:text>:</xsl:text></xsl:with-param>
            </xsl:call-template>
        </h2>
        <h3>
            <!--
            <a><xsl:attribute name="href"><xsl:text>http://www.openurl.info/registry/</xsl:text>
                  <xsl:choose>
                    <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='oai_dc'">dc</xsl:when>
                    <xsl:otherwise>
                      <xsl:value-of select="/oai:OAI-PMH/oai:request/@metadataPrefix"/>
                    </xsl:otherwise>
                  </xsl:choose>
                  <xsl:text>/</xsl:text><xsl:value-of select="oai:record/oai:header/oai:identifier"/></xsl:attribute>
            -->
            <xsl:value-of select="oai:record/oai:header/oai:identifier"/>
            <!--
            </a>
            -->
        </h3>
        <table width="100%" border="0" cellspacing="2" cellpadding="0">
            <xsl:apply-templates/>
        </table>
        <xsl:choose>
            <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix!='oai_dc'">
                <p><a><xsl:attribute name="href"><xsl:text>/openurl/servlet/OAIHandler?verb=GetRecord&amp;metadataPrefix=oai_dc&amp;identifier=</xsl:text><xsl:value-of select="oai:record/oai:header/oai:identifier"/></xsl:attribute>View Dublin Core metadata for this entry</a></p>
            </xsl:when>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="oai:ListMetadataFormats">
        <xsl:choose>
            <xsl:when test="/oai:OAI-PMH/oai:request/@identifier"><h2>Records available in this repository for <xsl:value-of select="/oai:OAI-PMH/oai:request/@identifier"/></h2></xsl:when>
            <xsl:otherwise><h2>Formats available in this repository</h2></xsl:otherwise>
        </xsl:choose>
        <table width="100%" border="0" cellspacing="0" cellpadding="4">
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="oai:ListSets">
        <h2>Components of OpenURL Framework</h2>
        <table width="100%" border="0" cellspacing="0" cellpadding="4">
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="oai:ListRecords">
        <h2>
            <xsl:choose>
                <xsl:when test="/oai:OAI-PMH/oai:request/@set">
                    <!--
                    <xsl:value-of select="/oai:OAI-PMH/oai:request/@set"/>
                    -->
                    <xsl:variable name="temp">
                        <xsl:call-template name="replace-substring">
                            <xsl:with-param name="value" select="/oai:OAI-PMH/oai:request/@set" />
                            <xsl:with-param name="from"><xsl:text>+</xsl:text></xsl:with-param>
                            <xsl:with-param name="to"><xsl:text> </xsl:text></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:call-template name="replace-substring">
                        <xsl:with-param name="value" select="$temp" />
                        <xsl:with-param name="from"><xsl:text>%3A</xsl:text></xsl:with-param>
                        <xsl:with-param name="to"><xsl:text>:</xsl:text></xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='xsd'">XML Schema definition</xsl:when>
                        <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='mtx'">Z39.88-2004 MTX definition</xsl:when>
                        <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='pro'">Community Profile Format</xsl:when>
                        <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='pro2004'">Community Profile Format (2004)</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="/oai:OAI-PMH/oai:request/@metadataPrefix"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </h2>
        <table width="100%" border="0" cellspacing="2" cellpadding="0">
            <xsl:apply-templates mode="brief"/>
        </table>
    </xsl:template>

    <xsl:template match="oai:ListIdentifiers">
        <h2>
            <xsl:choose>
                <xsl:when test="/oai:OAI-PMH/oai:request/@set">
                    <!--
                    <xsl:value-of select="/oai:OAI-PMH/oai:request/@set"/>
                    -->
                    <xsl:variable name="temp">
                        <xsl:call-template name="replace-substring">
                            <xsl:with-param name="value" select="/oai:OAI-PMH/oai:request/@set" />
                            <xsl:with-param name="from"><xsl:text>+</xsl:text></xsl:with-param>
                            <xsl:with-param name="to"><xsl:text> </xsl:text></xsl:with-param>
                        </xsl:call-template>
                    </xsl:variable>
                    <xsl:call-template name="replace-substring">
                        <xsl:with-param name="value" select="$temp" />
                        <xsl:with-param name="from"><xsl:text>%3A</xsl:text></xsl:with-param>
                        <xsl:with-param name="to"><xsl:text>:</xsl:text></xsl:with-param>
                    </xsl:call-template>
                </xsl:when>
                <xsl:otherwise>
                    <xsl:choose>
                        <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='xsd'">XML Schema definition</xsl:when>
                        <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='mtx'">Z39.88-2004 MTX definition</xsl:when>
                        <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='pro'">Community Profile Format</xsl:when>
                        <xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix='pro2004'">Community Profile Format (2004)</xsl:when>
                        <xsl:otherwise>
                            <xsl:value-of select="/oai:OAI-PMH/oai:request/@metadataPrefix"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:otherwise>
            </xsl:choose>
        </h2>
        <table width="100%" border="0" cellspacing="0" cellpadding="4">
            <xsl:for-each select="oai:header/oai:setSpec[generate-id(.)=generate-id(key('setSpecs',.)[1])]">
                <xsl:variable name="temp"><xsl:value-of select="/oai:OAI-PMH/oai:request/@set"/><xsl:text>:</xsl:text></xsl:variable>
                <xsl:if test="starts-with(.,$temp)">
                    <tr><td><strong><a><xsl:attribute name="href"><xsl:text>/openurl/servlet/OAIHandler?verb=ListRecords&amp;metadataPrefix=oai_dc&amp;set=</xsl:text><xsl:value-of select="."/></xsl:attribute>
                        <xsl:variable name="temp2">
                            <xsl:call-template name="replace-substring">
                                <xsl:with-param name="value" select="substring-after(.,$temp)" />
                                <xsl:with-param name="from"><xsl:text>+</xsl:text></xsl:with-param>
                                <xsl:with-param name="to"><xsl:text> </xsl:text></xsl:with-param>
                            </xsl:call-template>
                        </xsl:variable>
                        <xsl:call-template name="replace-substring">
                            <xsl:with-param name="value" select="$temp2" />
                            <xsl:with-param name="from"><xsl:text>%3A</xsl:text></xsl:with-param>
                            <xsl:with-param name="to"><xsl:text>:</xsl:text></xsl:with-param>
                        </xsl:call-template>
                    </a></strong></td></tr>
                </xsl:if>
            </xsl:for-each>
        </table>
    </xsl:template>

    <xsl:template match="oai:error">
        <h2><font color="red"><xsl:value-of select="name()"/></font></h2>
        <table width="100%" border="0" cellspacing="2" cellpadding="0">
            <tr valign="top">
                <td width="200"><strong><xsl:value-of select="@code"/></strong></td>
                <td><xsl:value-of select="."/></td>
            </tr>
        </table>
    </xsl:template>

    <xsl:template match="oai:record">
        <tr valign="top">
            <td>
                <table width="100%" border="0" cellspacing="2" cellpadding="0">
                    <xsl:apply-templates/>
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="oai:record" mode="brief">
        <tr valign="top">
            <td><strong><a><xsl:attribute name="href">
                <xsl:text>OAIHandler?verb=GetRecord&amp;metadataPrefix=</xsl:text><xsl:value-of select="/oai:OAI-PMH/oai:request/@metadataPrefix"/><xsl:text>&amp;identifier=</xsl:text><xsl:value-of select="oai:header/oai:identifier"/>
            </xsl:attribute><xsl:value-of select="oai:header/oai:identifier"/></a></strong></td>
            <td><font color="green"><strong><xsl:value-of select="oai:metadata/oai_dc:dc/dc:coverage"/></strong></font></td>
            <td><xsl:value-of select="oai:metadata/oai_dc:dc/dc:title"/></td>
            <!--
                      <xsl:apply-templates mode="brief"/>
            -->
        </tr>
    </xsl:template>

    <xsl:template match="oai:header">
    </xsl:template>

    <xsl:template match="oai:metadata" mode="brief">
        <tr valign="top">
            <td>
                <xsl:apply-templates mode="brief"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="oai:metadata">
        <tr valign="top">
            <td>
                <xsl:apply-templates mode="verboseTop"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="oai:about">
        <xsl:apply-templates />
    </xsl:template>

    <xsl:template match="provenance:provenance">
        <tr valign="top">
            <td bgcolor="#eeeeee">
                <table width="100%" border="0" cellspacing="4" cellpadding="0">
                    <tr valign="top">
                        <td width="150"><strong><xsl:value-of select="name()"/></strong></td>
                        <td>
                            <table width="100%" border="0" cellspacing="4" cellpadding="0">
                                <xsl:apply-templates />
                            </table>
                        </td>
                    </tr>
                </table>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="provenance:originDescription">
        <tr valign="top">
            <td width="150"><strong><xsl:value-of select="name()"/></strong></td>
        </tr>
        <xsl:apply-templates/>
    </xsl:template>

    <xsl:template match="provenance:*">
        <tr valign="top">
            <td width="150"><strong><xsl:value-of select="name()"/></strong></td>
            <td><xsl:value-of select="."/></td>
        </tr>
    </xsl:template>

    <xsl:template match="oai:set">
        <tr valign="top">
            <xsl:if test="starts-with(oai:setSpec,'Core:')">
                <xsl:apply-templates/>
            </xsl:if>
        </tr>
    </xsl:template>

    <xsl:template match="oai:setSpec">
    </xsl:template>

    <xsl:template match="oai:setName">
        <td><strong><a><xsl:attribute name="href">OAIHandler?verb=ListRecords&amp;metadataPrefix=oai_dc&amp;set=<xsl:value-of select="../oai:setSpec"/></xsl:attribute>
            <xsl:value-of select="."/></a></strong></td>
    </xsl:template>

    <xsl:template match="oai:responseDate">
    </xsl:template>

    <xsl:template match="oai:request">
    </xsl:template>

    <xsl:template match="oai:*">
        <tr valign="top">
            <td width="150"><strong><xsl:value-of select="name()"/></strong></td>
            <td><xsl:value-of select="."/></td>
        </tr>
    </xsl:template>

    <xsl:template match="oai:adminEmail">
        <tr valign="top">
            <td width="150"><strong><xsl:value-of select="name()"/></strong></td>
            <td><cite><a><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a></cite></td>
        </tr>
    </xsl:template>

    <xsl:template match="oai:resumptionToken">
        <tr valign="top">
            <td>ResumptionToken: <a><xsl:attribute name="href">OAIHandler?verb=<xsl:value-of select="//oai:OAI-PMH/oai:request/@verb"/>&amp;resumptionToken=<xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a></td>
        </tr>
    </xsl:template>

    <xsl:template match="oai:identifier">
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <td><a><xsl:attribute name="href">OAIHandler?verb=GetRecord&amp;metadataPrefix=<xsl:choose><xsl:when test="/oai:OAI-PMH/oai:request/@metadataPrefix"><xsl:value-of select="/oai:OAI-PMH/oai:request/@metadataPrefix"/></xsl:when><xsl:otherwise>oai_dc</xsl:otherwise></xsl:choose>&amp;identifier=<xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a></td>
        </tr>
    </xsl:template>

    <!--
      <xsl:template name="apply-templates-copy-all">
        <xsl:copy>
          <xsl:call-template name="apply-templates-copy-all"/>
        </xsl:copy>
      </xsl:template>
    -->

    <xsl:template match="oai:description">
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <td><xsl:apply-templates/></td>
        </tr>
    </xsl:template>

    <!--
      <xsl:template match="oai_id:oai-identifier">
        <table border="0">
          <tr valign="top"><td>OAI Identifier</td></tr>
          <xsl:apply-templates/>
        </table>
      </xsl:template>
    -->

    <xsl:template match="oai_id:oai-identifier">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top">
                <td><strong><xsl:value-of select="name()"/>:</strong></td>
            </tr>
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="oai_id:*">
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <td><xsl:apply-templates/></td>
        </tr>
    </xsl:template>

    <xsl:template match="oai_branding:branding">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <xsl:apply-templates/>
        </table>
    </xsl:template>

    <xsl:template match="oai_branding:metadataRendering">
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <td>
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="."/>
                    </xsl:attribute>
                    <xsl:attribute name="type">
                        <xsl:value-of select="@mimeType"/>
                    </xsl:attribute>
                    <xsl:value-of select="@metadataNamespace"/>
                </a>
            </td>
        </tr>
    </xsl:template>

    <!--
      <xsl:template match="oai_branding:metadataRendering>
        <tr valign="top">
          <td><strong><xsl:value-of select="name()"/></strong></td>
        </tr>
      </xsl:template>
    -->

    <xsl:template match="oai_branding:collectionIcon">
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <td>
                <!--
                <a href="http://alcme.oclc.org/openurl/index.html"><img src="http://alcme.oclc.org/openurl/oaicat_icon.gif" alt="Testing"/></a>
                -->
                <a>
                    <xsl:attribute name="href">
                        <xsl:value-of select="oai_branding:link"/>
                    </xsl:attribute>
                    <img>
                        <xsl:attribute name="width">
                            <xsl:value-of select="oai_branding:width"/>
                        </xsl:attribute>
                        <xsl:attribute name="height">
                            <xsl:value-of select="oai_branding:height"/>
                        </xsl:attribute>
                        <xsl:attribute name="src">
                            <xsl:value-of select="oai_branding:url"/>
                        </xsl:attribute>
                        <xsl:attribute name="alt">
                            <xsl:value-of select="oai_branding:title"/>
                        </xsl:attribute>
                    </img>
                </a>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="oai_branding:*">
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <td><xsl:apply-templates/></td>
        </tr>
    </xsl:template>

    <xsl:template match="oai:metadataFormat">
        <xsl:choose>
            <xsl:when test="/oai:OAI-PMH/oai:request/@identifier">
                <tr valign="top"><td><a><xsl:attribute name="href">OAIHandler?verb=GetRecord&amp;metadataPrefix=<xsl:value-of select="oai:metadataPrefix"/>&amp;identifier=<xsl:value-of select="/oai:OAI-PMH/oai:request/@identifier"/></xsl:attribute><xsl:choose><xsl:when test="oai:metadataPrefix='oai_dc'"></xsl:when><xsl:when test="oai:metadataPrefix='mtx'">Z39.88-2004 MTX definition</xsl:when><xsl:when test="oai:metadataPrefix='pro'">Community Profile Format</xsl:when><xsl:when test="oai:metadataPrefix='xsd'">XML Schema definition</xsl:when><xsl:otherwise><xsl:value-of select="oai:metadataPrefix"/></xsl:otherwise></xsl:choose></a></td></tr>
            </xsl:when>
            <xsl:otherwise>
                <tr valign="top"><td><a><xsl:attribute name="href">OAIHandler?verb=ListRecords&amp;metadataPrefix=<xsl:value-of select="oai:metadataPrefix"/></xsl:attribute><xsl:choose><xsl:when test="oai:metadataPrefix='oai_dc'"></xsl:when><xsl:when test="oai:metadataPrefix='mtx'">Z39.88-2004 MTX definition</xsl:when><xsl:when test="oai:metadataPrefix='pro'">Community Profile Format</xsl:when><xsl:when test="oai:metadataPrefix='xsd'">XML Schema definition</xsl:when><xsl:otherwise><xsl:value-of select="oai:metadataPrefix"/></xsl:otherwise></xsl:choose></a></td></tr>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>

    <xsl:template match="oai_dc:dc" mode="brief">
        <xsl:apply-templates mode="brief"/>
    </xsl:template>

    <xsl:template match="oai_dc:dc" mode="verboseTop">
        <table width="100%" border="0" cellspacing="4" cellpadding="0">
            <xsl:apply-templates mode="verbose"/>
        </table>
    </xsl:template>

    <xsl:template match="dc:identifier" mode="verbose">
        <xsl:variable name="myURL">
            <xsl:choose>
                <xsl:when test="substring-after(., 'http:')">
                    <xsl:choose>
                        <xsl:when test="substring-before(substring-after(.,'http:'),')')">
                            <xsl:text>http:</xsl:text><xsl:value-of select="substring-before(substring-after(.,'http:'),')')"/>
                        </xsl:when>
                        <xsl:otherwise>
                            <xsl:text>http:</xsl:text><xsl:value-of select="substring-after(.,'http:')"/>
                        </xsl:otherwise>
                    </xsl:choose>
                </xsl:when>
                <xsl:otherwise/>
            </xsl:choose>
        </xsl:variable>
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <td><xsl:value-of select="substring-before(.,$myURL)"/>
                <a target="_blank"><xsl:attribute name="href"><xsl:text>javascript:location.href='</xsl:text><xsl:value-of select="$myURL"/><xsl:text>'</xsl:text></xsl:attribute><xsl:value-of select="$myURL"/></a><xsl:value-of select="substring-after(.,$myURL)"/>
            </td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:source" mode="verbose">
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <xsl:choose>
                <xsl:when test="substring(.,1,5)='http:'">
                    <td><a target="_blank"><xsl:attribute name="href"><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a></td>
                </xsl:when>
                <xsl:otherwise>
                    <td><xsl:value-of select="."/></td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>

    <xsl:template match="dc:relation" mode="verbose">
        <tr valign="top">
            <td><strong><xsl:value-of select="name()"/></strong></td>
            <xsl:choose>
                <xsl:when test="contains(.,'http://')">
                    <xsl:variable name="url">
                        <xsl:variable name="temp">
                            <xsl:text>http://</xsl:text>
                            <xsl:value-of select="substring-after(.,'http://')" />
                        </xsl:variable>
                        <xsl:choose>
                            <xsl:when test="contains($temp,')')">
                                <xsl:value-of select="substring-before($temp,')')" />
                            </xsl:when>
                            <xsl:otherwise>
                                <xsl:value-of select="$temp" />
                            </xsl:otherwise>
                        </xsl:choose>
                    </xsl:variable>
                    <td>
                        <xsl:value-of select="substring-before(.,'http://')"/>
                        <a target="_blank">
                            <xsl:attribute name="href">
                                <xsl:value-of select="$url"/>
                            </xsl:attribute>
                            <xsl:value-of select="$url"/>
                        </a>
                        <xsl:value-of select="substring-after(.,$url)" />
                    </td>
                </xsl:when>
                <xsl:otherwise>
                    <td><xsl:value-of select="."/></td>
                </xsl:otherwise>
            </xsl:choose>
        </tr>
    </xsl:template>

    <xsl:template match="dc:*" mode="brief">
    </xsl:template>

    <xsl:template match="dc:*" mode="verbose">
        <tr valign="top">
            <td width="150"><strong><xsl:value-of select="name()"/></strong></td>
            <td><xsl:value-of select="."/></td>
        </tr>
    </xsl:template>

    <xsl:template match="dc:type" mode="verbose">
        <tr valign="top">
            <td width="150"><strong><xsl:value-of select="name()"/></strong></td>
            <td><a><xsl:attribute name="href"><xsl:text>OAIHandler?verb=ListRecords&amp;metadataPrefix=oai_dc&amp;set=</xsl:text><xsl:value-of select="."/></xsl:attribute><xsl:value-of select="."/></a></td>
        </tr>
    </xsl:template>

    <xsl:template match="toolkit:toolkit">
        <table width="100%" border="0" cellspacing="0" cellpadding="0">
            <tr valign="top"><td width="150"><strong><xsl:value-of select="name()"/></strong></td>
                <td>
                    <a>
                        <xsl:attribute name="href">
                            <xsl:value-of select="toolkit:URL"/>
                        </xsl:attribute>
                        <img border="0" cellspacing="0" cellpadding="0">
                            <xsl:attribute name="alt">
                                <xsl:value-of select="toolkit:title"/>
                            </xsl:attribute>
                            <xsl:attribute name="src">
                                <xsl:value-of select="toolkit:toolkitIcon"/>
                            </xsl:attribute>
                        </img>
                    </a>
                    (version <xsl:value-of select="toolkit:version"/>)
                </td>
            </tr>
        </table>
    </xsl:template>

    <!--
      IE5 default style sheet, provides a view of any XML document
      and provides the following features:
      - auto-indenting of the display, expanding of entity references
      - click or tab/return to expand/collapse
      - color coding of markup
      - color coding of recognized namespaces - xml, xmlns, xsl, dt

      This style sheet is available in IE5 in a compact form at the URL
      "res://msxml.dll/DEFAULTSS.xsl".  This version differs only in the
      addition of comments and whitespace for readability.

      Author:  Jonathan Marsh (jmarsh@microsoft.com)
      Modified:   05/21/2001 by Nate Austin (naustin@idsgrp.com)
                             Converted to use XSLT rather than WD-xsl
    -->

    <!-- Templates for each node type follows.  The output of each template has a similar structure
      to enable script to walk the result tree easily for handling user interaction. -->

    <!-- Template for the DOCTYPE declaration.  No way to get the DOCTYPE, so we just put in a placeholder -->
    <!--  no support for doctypes
    <xsl:template match="node()[nodeType()=10]" mode="verbose">
      <DIV class="e"><SPAN>
      <SPAN class="b">&#160;</SPAN>
      <SPAN class="d">&lt;!DOCTYPE <xsl:value-of select="name()"/><I> (View Source for full doctype...)</I>&gt;</SPAN>
      </SPAN></DIV>
    </xsl:template>
    -->

    <!-- Template for pis not handled elsewhere -->
    <xsl:template match="processing-instruction()" mode="verbose">
        <DIV class="e">
            <SPAN class="b">&#160;</SPAN>
            <SPAN class="m">&lt;?</SPAN><SPAN class="pi"><xsl:value-of select="name()"/>&#160;<xsl:value-of select="."/></SPAN><SPAN class="m">?&gt;</SPAN>
        </DIV>
    </xsl:template>

    <!-- Template for the XML declaration.  Need a separate template because the pseudo-attributes
        are actually exposed as attributes instead of just element content, as in other pis -->
    <!--  No support for the xml declaration
    <xsl:template match="pi('xml')" mode="verbose">
      <DIV class="e">
      <SPAN class="b">&#160;</SPAN>
      <SPAN class="m">&lt;?</SPAN><SPAN class="pi">xml <xsl:for-each select="@*"><xsl:value-of select="name()"/>="<xsl:value-of select="."/>"</xsl:for-each></SPAN><SPAN class="m">?&gt;</SPAN>
      </DIV>
    </xsl:template>
    -->

    <!-- Template for attributes not handled elsewhere -->
    <xsl:template match="@*" xml:space="preserve" mode="verbose"><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute> <xsl:value-of select="name()" /></SPAN><SPAN class="m">="</SPAN><B><xsl:value-of select="."/></B><SPAN class="m">"</SPAN></xsl:template>

    <!-- Template for attributes in the xmlns or xml namespace -->
    <!--xsl:template match="@xmlns:*|@xmlns|@xml:*" mode="verbose"><SPAN class="ns"> <xsl:value-of
    select="name()"/></SPAN><SPAN class="m">="</SPAN><B class="ns"><xsl:value-of
    select="."/></B><SPAN class="m">"</SPAN></xsl:template-->

    <!-- Template for attributes in the dt namespace -->
    <xsl:template match="@dt:*|@d2:*" mode="verbose"><SPAN class="dt"> <xsl:value-of select="name()"/></SPAN><SPAN class="m">="</SPAN><B class="dt"><xsl:value-of select="."/></B><SPAN class="m">"</SPAN></xsl:template>

    <!-- Template for text nodes -->
    <xsl:template match="text()" mode="verbose">
        <DIV class="e">
            <SPAN class="b">&#160;</SPAN>
            <SPAN class="tx"><xsl:value-of select="."/></SPAN>
        </DIV>
    </xsl:template>


    <!-- Note that in the following templates for comments and cdata, by default we apply a style
      appropriate for single line content (e.g. non-expandable, single line display).  But we also
      inject the attribute 'id="clean"' and a script call 'f(clean)'.  As the output is read by the
      browser, it executes the function immediately.  The function checks to see if the comment or
      cdata has multi-line data, in which case it changes the style to a expandable, multi-line
      display.  Performing this switch in the DHTML instead of from script in the XSL increases
      the performance of the style sheet, especially in the browser's asynchronous case -->

    <!-- Template for comment nodes -->
    <xsl:template match="comment()" mode="verbose">
        <DIV class="k">
            <SPAN><A class="b" onclick="return false" onfocus="h()" STYLE="visibility:hidden">-</A> <SPAN class="m">&lt;!--</SPAN></SPAN>
            <SPAN id="clean" class="ci"><PRE><xsl:value-of select="."/></PRE></SPAN>
            <SPAN class="b">&#160;</SPAN> <SPAN class="m">--&gt;</SPAN>
            <SCRIPT>f(clean);</SCRIPT></DIV>
    </xsl:template>

    <!-- Template for cdata nodes -->
    <!-- UNSUPPORTED
    <xsl:template match="cdata()" mode="verbose">
      <DIV class="k">
      <SPAN><A class="b" onclick="return false" onfocus="h()" STYLE="visibility:hidden">-</A> <SPAN class="m">&lt;![CDATA[</SPAN></SPAN>
      <SPAN id="clean" class="di"><PRE><xsl:value-of select="."/></PRE></SPAN>
      <SPAN class="b">&#160;</SPAN> <SPAN class="m">]]&gt;</SPAN>
      <SCRIPT>f(clean);</SCRIPT></DIV>
    </xsl:template>
    -->


    <!-- Note the following templates for elements may examine children.  This harms to some extent
      the ability to process a document asynchronously - we can't process an element until we have
      read and examined at least some of its children.  Specifically, the first element child must
      be read before any template can be chosen.  And any element that does not have element
      children must be read completely before the correct template can be chosen. This seems
      an acceptable performance loss in the light of the formatting possibilities available
      when examining children. -->

    <!-- Template for elements not handled elsewhere (leaf nodes) -->
    <xsl:template match="xs:*|pro:*" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pro="info:ofi/pro" mode="verbose">
        <DIV class="e"><DIV STYLE="margin-left:1em;text-indent:-2em">
            <SPAN class="b">&#160;</SPAN>
            <SPAN class="m">&lt;</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN> <xsl:apply-templates select="@*" mode="verbose"/><SPAN class="m">
            /&gt;</SPAN>
        </DIV></DIV>
    </xsl:template>

    <!-- Template for elements with comment, pi and/or cdata children -->
    <xsl:template match="xs:*[comment() | processing-instruction()]|pro:*[comment() | processing-instruction()]" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pro="info:ofi/pro" mode="verbose">
        <DIV class="e">
            <DIV class="c"><A href="#" onclick="return false" onfocus="h()" class="b">-</A> <SPAN class="m">&lt;</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN><xsl:apply-templates select="@*" mode="verbose"/> <SPAN class="m">&gt;</SPAN></DIV>
            <DIV><xsl:apply-templates mode="verbose"/>
                <DIV><SPAN class="b">&#160;</SPAN> <SPAN class="m">&lt;/</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN><SPAN class="m">&gt;</SPAN></DIV>
            </DIV></DIV>
    </xsl:template>

    <!-- Template for elements with only text children -->
    <xsl:template match="xs:*[text() and not(comment() | processing-instruction())]|pro:*[text() and not(comment() | processing-instruction())]" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pro="info:ofi/pro" mode="verbose">
        <DIV class="e"><DIV STYLE="margin-left:1em;text-indent:-2em">
            <SPAN class="b">&#160;</SPAN> <SPAN class="m">&lt;</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN><xsl:apply-templates select="@*" mode="verbose"/>
            <SPAN class="m">&gt;</SPAN><SPAN class="tx"><xsl:value-of select="."/></SPAN><SPAN class="m">&lt;/</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN><SPAN class="m">&gt;</SPAN>
        </DIV></DIV>
    </xsl:template>

    <!-- Template for elements with element children -->
    <xsl:template match="xs:*[xs:*]|pro:*[pro:*]" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pro="info:ofi/pro" mode="verbose">
        <DIV class="e">
            <DIV class="c" STYLE="margin-left:1em;text-indent:-2em"><A href="#" onclick="return false" onfocus="h()" class="b">-</A> <SPAN class="m">&lt;</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN><xsl:apply-templates select="@*" mode="verbose"/> <SPAN class="m">&gt;</SPAN></DIV>
            <DIV><xsl:apply-templates mode="verbose"/>
                <DIV><SPAN class="b">&#160;</SPAN> <SPAN class="m">&lt;/</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN><SPAN class="m">&gt;</SPAN></DIV>
            </DIV></DIV>
    </xsl:template>

    <!-- Template for elements with element children -->
    <xsl:template match="xs:schema[xs:*]|pro:profile[pro:*]" xmlns:xs="http://www.w3.org/2001/XMLSchema" xmlns:pro="info:ofi/pro" mode="verboseTop">
        <DIV class="e">
            <DIV class="c" STYLE="margin-left:1em;text-indent:-2em"><A href="#" onclick="return false" onfocus="h()" class="b">-</A> <SPAN class="m">&lt;</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN><xsl:apply-templates select="@*" mode="verbose"/> <SPAN class="m">&gt;</SPAN></DIV>
            <DIV><xsl:apply-templates mode="verbose"/>
                <DIV><SPAN class="b">&#160;</SPAN> <SPAN class="m">&lt;/</SPAN><SPAN><xsl:attribute name="class"><xsl:if test="starts-with(name(),'xsl:')">x</xsl:if>t</xsl:attribute><xsl:value-of select="name()"/></SPAN><SPAN class="m">&gt;</SPAN></DIV>
            </DIV></DIV>
    </xsl:template>

    <!-- Template for elements with element children -->
    <xsl:template match="xhtml:html[xhtml:*]" xmlns:xhtml="http://www.w3.org/1999/xhtml" mode="verboseTop">
        <table border="1">
            <tr><td><xsl:copy-of select="xhtml:body/*"/></td></tr>
        </table>
    </xsl:template>

    <xsl:template name="replace-substring">
        <xsl:param name="value"/>
        <xsl:param name="from"/>
        <xsl:param name="to"/>
        <xsl:choose>
            <xsl:when test="contains($value,$from)">
                <xsl:value-of select="substring-before($value,$from)"/>
                <xsl:value-of select="$to"/>
                <xsl:call-template name="replace-substring">
                    <xsl:with-param name="value" select="substring-after($value,$from)"/>
                    <xsl:with-param name="from" select="$from"/>
                    <xsl:with-param name="to" select="$to"/>
                </xsl:call-template>
            </xsl:when>
            <xsl:otherwise>
                <xsl:value-of select="$value"/>
            </xsl:otherwise>
        </xsl:choose>
    </xsl:template>
</xsl:stylesheet>
