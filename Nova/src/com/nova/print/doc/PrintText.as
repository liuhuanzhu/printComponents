package com.nova.print.doc
{
	import com.nova.print.control.NovaText;
	import com.nova.print.map.DataMap;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;
	
	import mx.messaging.channels.StreamingAMFChannel;

	public class PrintText extends Sprite
	{
		private var type:String;
		private var xml:XML;
		public function PrintText(_type:String)
		{
			type=_type;
			creat();
		}
		private function creat():void
		{
			if(type=="top")
			{
				xml=LayoutMap.getSimple().topXml;
			}
			else
			{
				xml=LayoutMap.getSimple().bottomXml;
			}
			if(xml==null) return;
			//trace("加载"+type+"------------------------------------start");
			for(var i:int=0;i<xml.children().length();i++)
			{
				var xx:XML=xml.children()[i] as XML;
				var ID:String=xx.@id;
				var tx:Number=Number(xx.@x);
				var ty:Number=Number(xx.@y);
				var size:String=xx.@fontSize;
				var align:String=xx.@textAlign;
				var height:int=Number(xx.@height);
				
				var border:Boolean=xx.@border=="true"?true:false;
				if(align.length==0)
				{
					align="left";
				}
				var width:int=Number(xx.@width);
				var wrap:String=xx.@wrap;
				if(ID.length>0)
				{
					if(wrap.length>0)
					{
						creatWrapTxt(ID,tx,ty,size,width,align);
					}
					else
					{
						var nt:NovaText=new NovaText(findById(ID),align,size,width,height,border);
						nt.x=tx;
						nt.y=ty;
						this.addChild(nt);
					}
				}
				if(!SetupInfo.getInstance().printIsTaoda && ID.length==0)
				{
					var bt:NovaText=new NovaText(xx.@text,"left",size,width,height,border);
					bt.x=tx;
					bt.y=ty;
					this.addChild(bt);
					//trace("加载标题的数据为:  "+xx.@text+"   X: "+tx+"    Y:"+ty);
				}
			}
			//trace("加载"+type+"------------------------------------end");
		}
		private function findById(ID:String):String
		{
			var text:String="";
			for(var i:int=0;i<DataMap.getSimple().tfData.length;i++)
			{
				var obj:Object=DataMap.getSimple().tfData.getItemAt(i);
				if(obj.id==ID)
				{
					text=obj.text;
				}
			}
			return text;
		}
		private function creatWrapTxt(ID:String,tx:int,ty:int,size:String,width:int,align:String):void
		{
			var text:String=findById(ID);
			var txtArray:Array=text.split("\n");
			for(var i:int=0;i<txtArray.length;i++)
			{
				var nt:NovaText=new NovaText(txtArray[i],"left",size,width);
				nt.x=tx;
				nt.y=ty+i*22;
				//trace("加载换行的数据为:  "+txtArray[i]+"   X: "+tx+"    Y:"+ty);
				this.addChild(nt);
			}
		}
	}
}