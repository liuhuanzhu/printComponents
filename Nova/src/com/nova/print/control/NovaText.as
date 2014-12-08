package com.nova.print.control
{
	import com.nova.print.util.SetupInfo;
	
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class NovaText extends TextField
	{
		private var txtFormat:TextFormat=null;
		public function NovaText(txt:String,align:String,size:String,_width:int=0)
		{
			super();
			if(txt==null)
			{
				txt="";
			}
			this.text=txt;
			if(_width!=0)
			{
				this.width=_width;
			}
			else
			{
				this.width=this.textWidth+20;
			}
			txtFormat=new TextFormat();
			if(size.length==0)
			{
				txtFormat.size=10;
			}
			else
			{
				txtFormat.size=Number(size);
				
			}
			txtFormat.align=align;
			txtFormat.font="SONG";
			txtFormat.bold=true;
			this.embedFonts=true;
			this.setTextFormat(txtFormat);
			this.mouseEnabled=false;
			this.wordWrap=false;
			this.height=40;
		}
	}
}