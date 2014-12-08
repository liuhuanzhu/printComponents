package com.nova.print.map
{
	import com.nova.print.control.NovaLabel;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.TextField;
	import flash.text.TextFormat;
	
	import mx.collections.ArrayCollection;
	import mx.collections.ArrayList;
	import mx.controls.DataGrid;
	import mx.controls.dataGridClasses.DataGridColumn;
	import mx.core.UIComponent;
	
	import spark.components.Label;
	
	
	public class TaoDa
	{
		private static var taoda:TaoDa=null;
		public static function getInstance():TaoDa
		{
			if(taoda==null)
			{
				taoda=new TaoDa();
			}
			return taoda;
		}
		public function setLabelTaoDa(label:TextField,parentBounds:UIComponent,parent:Sprite):void
		{
			if(label.name=="")return
			else
			var text:TextField=new TextField();
			text.x=label.x;
			text.y=label.y;
			var txt:String="";
			txt=NovaLabel.getInstance().findById(label.name);
			text.text=txt;
			text.width=txt.length*18+2;
			text.mouseEnabled=false;
			text.selectable=false;
			var tf:TextFormat=new TextFormat();
			text.setTextFormat(tf);
			//trace("套打Label:  "+"内容: "+text.text+"--->X坐标:"+text.x+"--->Y坐标: "+text.y);
			parent.addChild(text);
		}
		public function setDataGrid(dataGrid:DataGrid,parentBounds:UIComponent,parent:Sprite):void
		{
			var contentSprite:Sprite=new Sprite();
			var headSprite:Sprite=new Sprite();
			var lineSprite:Sprite=new Sprite();
			lineSprite.graphics.lineStyle(1,0x000000);
			if(SetupInfo.getInstance().isPrintHeader)
			{
				lineSprite.graphics.moveTo(0,-25);
				lineSprite.graphics.lineTo(dataGrid.width,-25);
			}
			var array:ArrayCollection=dataGrid.dataProvider as ArrayCollection;
			var width:Number=dataGrid.width;
			var height:Number=dataGrid.height;
			var font:String=dataGrid.getStyle("fontFamily");
			var size:String=dataGrid.getStyle("fontSize");
			var tf:TextFormat=new TextFormat();
			tf.size=size;
			tf.font=font;
			var columns:Array = dataGrid.columns as Array;
			var columnWidth:Number=0;
			var columnWidthArray:Array=[];
			columnWidthArray.push(0);
			for(var i:int=0;i<columns.length;i++)
			{
				var grid:DataGridColumn=columns[i] as DataGridColumn;
				var headText:TextField=new TextField();
				headText.mouseEnabled=false;
				headText.selectable=false;
				headText.text=grid.headerText;
				headText.x=columnWidth;
				headText.y=-25;
				headText.height=24;
				//竖线
				if(SetupInfo.getInstance().isPrintHeader)
				{
					lineSprite.graphics.moveTo(columnWidth,-25);
					lineSprite.graphics.lineTo(columnWidth,dataGrid.height-25);
				}
				else
				{
					lineSprite.graphics.moveTo(columnWidth,0);
					lineSprite.graphics.lineTo(columnWidth,dataGrid.height-25);	
				}
				
				headSprite.addChild(headText);
				columnWidth+=grid.width;
				columnWidthArray.push(columnWidth);
				
				
				for(var j:int=0;j<array.length;j++)
				{
					var object:Object=array.getItemAt(j);
					var text:TextField=new TextField();
					text.text=object[grid.dataField];
					text.x=columnWidthArray[i];
					text.y=25*j;
					text.mouseEnabled=false;
					text.selectable=false;
					text.setTextFormat(tf);
					contentSprite.addChild(text);
					lineSprite.graphics.moveTo(0,text.y);
					lineSprite.graphics.lineTo(dataGrid.width,text.y);
				}
				
			}
			if(SetupInfo.getInstance().isPrintHeader)
			{
				lineSprite.graphics.moveTo(dataGrid.width,-25);
				lineSprite.graphics.lineTo(dataGrid.width,dataGrid.height-25);
			}
			else
			{
				lineSprite.graphics.moveTo(dataGrid.width,0);
				lineSprite.graphics.lineTo(dataGrid.width,dataGrid.height-25);
			}
			
			lineSprite.graphics.moveTo(0,dataGrid.height-25);
			lineSprite.graphics.lineTo(dataGrid.width,dataGrid.height-25);
			lineSprite.graphics.endFill();
			contentSprite.x=dataGrid.x;
			contentSprite.y=dataGrid.y+dataGrid.headerHeight;
			if(SetupInfo.getInstance().isPrintHeader)
			{
				contentSprite.addChild(headSprite);
			}
			if(SetupInfo.getInstance().isPrintLines)
			{
				contentSprite.addChild(lineSprite);
			}
			parent.addChild(contentSprite);
		}
		private function setDataGridHeader(dataGrid:DataGrid,parent:UIComponent):void
		{
			
		}
	}
	
}