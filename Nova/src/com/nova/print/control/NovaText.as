package com.nova.print.control
{
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.TextField;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.text.engine.SpaceJustifier;
	
	public class NovaText extends Sprite
	{
		private var txtFormat:TextFormat=null;
		private var tf:TextField;
		private var shape:Shape;
		private var border:Boolean;
		public function NovaText(txt:String,align:String,size:String,_width:int=0,_height:int=0,_border:Boolean=false,wrap:Boolean=false)
		{
			super();
			tf=new TextField();
			this.addChild(tf);
			if(txt==null)
			{
				txt="";
			}
			tf.text=txt;
			if(_width!=0)
			{
				tf.width=_width;
			}
			else
			{
				tf.width=tf.textWidth+20;
			}
			if(_height!=0)
			{
				tf.height=_height;
			}
			else
			{
				tf.height=40;
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
			tf.embedFonts=true;
			tf.setTextFormat(txtFormat);
			tf.mouseEnabled=false;
			tf.wordWrap=wrap;
			border=_border;
			if(_border)
			{
				creatLine();
			}
		}
		private function creatLine():void
		{
			tf.y=5;
			shape=new Shape();
			shape.graphics.lineStyle(1,0x000000);
			shape.graphics.beginFill(0x000000,0);
			shape.graphics.drawRect(0,0,tf.width,tf.height);
			shape.graphics.endFill();
			this.addChild(shape);
		}
		public function clearLine():void
		{
			if(border)
			{
				shape.graphics.clear();
			}
		}
	}
}