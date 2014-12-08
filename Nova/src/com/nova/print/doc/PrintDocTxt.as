package com.nova.print.doc
{
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	import mx.controls.Text;

	public class PrintDocTxt extends Sprite
	{
		private var txtFormat:TextFormat;
		private var txtField:TextField=null;
		private var maskSprite:Sprite=null;
		private var txtWidth:int=0;
		public function PrintDocTxt(txt:String,_algin:String,_width:int,letter:int=0)
		{
			txtField=new TextField();
			txtFormat=new TextFormat();
			txtFormat.font="SONG";
			txtFormat.kerning=true;
			txtFormat.letterSpacing=letter;
			txtFormat.size=10;
			txtFormat.align=_algin;
			txtField.width=_width;
			txtWidth=_width;
			txtField.embedFonts=true;
			txtField.wordWrap=false;
			if(txt==null)
			{
				txt="";
			}
			txtField.text=txt;
			txtField.height=20;
			txtField.setTextFormat(txtFormat);
			maskSprite=new Sprite();
			maskSprite.graphics.lineStyle(1);
			maskSprite.graphics.beginFill(0xffcccc,0.1);
			maskSprite.graphics.drawRect(1,0,_width-1,20);
			maskSprite.graphics.endFill();
			
			
			this.addChild(txtField);
		}
		public function creatBg(bol:Boolean=true):void
		{
			if(bol)
			{
				txtField.mask=maskSprite;
				this.addChild(maskSprite);
			}
		}
	}
}