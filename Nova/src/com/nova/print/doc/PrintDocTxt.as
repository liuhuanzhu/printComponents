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
		private var adjustHeight:int=2;//调整的高度  合计行不换行后 垂直居中需要调整。
		public function PrintDocTxt(txt:String,_algin:String,_width:int,_height:int=20,isWrap:Boolean=false,letter:int=0)
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
			if(txt==null)
			{
				txt="";
			}
			txtField.text=txt;
			txtField.height=_height;
			txtField.wordWrap=isWrap;
			txtField.setTextFormat(txtFormat);
			maskSprite=new Sprite();
			maskSprite.graphics.lineStyle(1);
			maskSprite.graphics.beginFill(0xffcccc,0.1);
			maskSprite.graphics.drawRect(1,0,_width-1,_height);
			maskSprite.graphics.endFill();

			this.addChild(txtField);
		}
		public function creatBg(bol:Boolean=true):void
		{
			txtField.y=(txtField.height-txtField.textHeight)/2-adjustHeight;
			if(bol)
			{
				txtField.mask=maskSprite;
				this.addChild(maskSprite);
			}
			else
			{
				txtField.wordWrap=false;
				if(Math.ceil(txtField.height/25)>=2)
				{
					txtField.y+=txtField.textHeight/2;
				}
			}
		}
	}
}