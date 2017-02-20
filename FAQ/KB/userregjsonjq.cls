Class KB.userregjsonjq Extends %CSP.Page
{

/// Event handler for <b>PAGE</b> event: this is invoked in order to  
/// generate the content of a csp page.
ClassMethod OnPage() As %Status [ ServerOnly = 1 ]
{
 set tLocale = $$SetIO^%NLS("UTF8")
 Set tError = $$$OK
 Set sts = $$$OK
 Set tNamespace = $namespace
 Try {
   Zn "%SYS"
   set RegisterInfo = %request.Data("registerInfo",1)
   do ##class(%ZEN.Auxiliary.jsonProvider).%ConvertJSONToObject(RegisterInfo,,.tUserOBJ)
   set Username = tUserOBJ.Username
   set Password = tUserOBJ.Password
   set Name = tUserOBJ.Name
   set Company = tUserOBJ.Company
   set Email = tUserOBJ.Email
   set Dep = tUserOBJ.Dep
   set Confirm = tUserOBJ.Confirm
   If $Get(Username)="" set Error="���[�U������͂��ĉ�����" THROW ##class(%Exception.General).%New("���[�U�[�o�^�G���[","996",,Error)  
   If $classmethod("Security.Users","Exists",Username,.sts) Set Error="���[�U���́A���ɓo�^����Ă��܂��B���̃��[�U�������g����������" THROW ##class(%Exception.General).%New("���[�U�[�o�^�G���[","991",,Error)
   If $Get(Password)'=$Get(Confirm) Set Error="�p�X���[�h�m�F���ł��܂���ł����B" THROW ##class(%Exception.General).%New("���[�U�[�o�^�G���[","992",,Error)
   If $Get(Name)="" Set Error="�����O�̓��͂����肢���܂��B" THROW ##class(%Exception.General).%New("���[�U�[�o�^�G���[","993",,Error)
   If $Get(Company)="" Set Error="��Ж��i���邢�͏����g�D���j�̓��͂����肢���܂��B" THROW ##class(%Exception.General).%New("���[�U�[�o�^�G���[","994",,Error)
   If $Get(Email)="" Set Error="E-mail�A�h���X�̓��͂����肢���܂��B" THROW ##class(%Exception.General).%New("���[�U�[�o�^�G���[","995",,Error)
   Set sts = $classmethod("Security.Users","Create",Username,,Password,Name,,,,,1,$Listbuild(Email,Company,Dep))
 }
 catch ErrorH {
	 set tErrorText = ErrorH.Data
	 set tError = ErrorH.AsStatus()
 }
 Zn tNamespace
 If $$$ISERR(tError) Write tErrorText,! Quit $$$OK
 If $$$ISERR(sts) Write $system.Status.DisplayError(sts) Quit $$$OK
 
 //�ȉ��̃R�[�h�𓮍삳���邽�߂ɂ�SMTP�֘A�̐ݒ肪�K�v
 // smtp�T�[�o�[�̃A�h���X
 // smtp�T�[�o�[�̃|�[�g�ԍ��i�f�t�H���g25�ł͂Ȃ��ꍇ�j
 // ���[���̑��M�A�h���X
 // smtp�̔F�؃��[�U�[�ƃp�X���[�h
 
 Set s=##class(%Net.SMTP).%New()
 Set s.smtpserver=$Get(^Techinfo("SMTP Server"))
 set auth=##class(%Net.Authenticator).%New() ; use default authentication list
 set auth.UserName="zzz"
 set auth.Password="zzz"
 set s.authenticator=auth
 Set m=##class(%Net.MailMessage).%New()
 Set m.From=$Get(^Techinfo("Mail Sender"))
 Do m.To.Insert(Email)
 Set m.Subject="Cach&eacute;�\�����[�V�����y�[�W�ւ̃��[�U���o�^"
 Set m.Charset = "ISO-2022-JP"
 Set crlf=$C(13,10)
 Do m.TextData.Write("���̂��т́ACach&eacute;�\�����[�V�����y�[�W�ւ̃��[�U���o�^")
 Do m.TextData.Write("���ɂ��肪�Ƃ��������܂��B")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("���q�l�̃��[�U���A�p�X���[�h�́A�ȉ��̗l�ɂȂ��Ă��܂��B")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("���[�U��: "_Username)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("�p�X���[�h: "_Password)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("����Ƃ�Cach&eacute;�������ڂ��������܂��悤�A")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("��낵�����肢�\���グ�܂��B")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("�C���^�[�V�X�e���Y�W���p���������")
 Do m.TextData.Write(crlf)
 Do m.TextData.Write(crlf)
 Do m.TextData.Write("���{���[���̈ꕔ�A�܂��͑S���̖��f�]�ڂ��ւ��܂��B")
 Do m.TextData.Write(crlf)
 set status=s.Send(m)
 If $$$ISERR(status) Write $System.Status.GetErrorText(status) Quit $$$OK
 write "�o�^���܂���",! quit $$$OK
}

/// Event handler for <b>PreHTTP</b> event: this is invoked before
/// the HTTP headers for a CSP page have been sent.  All changes to the
/// <class>%CSP.Response</class> class, such as adding cookies, HTTP headers,
/// setting the content type etc. must be made from within the OnPreHTTP() method.
/// Also changes to the state of the CSP application such as changing
/// %session.EndSession or %session.AppTimeout must be made within the OnPreHTTP() method.
/// It is prefered that changes to %session.Preserve are also made in the OnPreHTTP() method
/// as this is more efficient, although it is supported in any section of the page.
/// Return <b>0</b> to prevent <method>OnPage</method> from being called.
ClassMethod OnPreHTTP() As %Boolean [ ServerOnly = 1 ]
{
    Set %response.ContentType = "text/plain" //So the browser understands that this is JSONP
    Quit $$$OK
}

}