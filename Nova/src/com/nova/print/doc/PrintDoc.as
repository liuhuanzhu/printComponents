package com.nova.print.doc
{
	import com.greensock.TweenLite;
	import com.greensock.easing.Elastic;
	import com.nova.print.map.LayoutMap;
	import com.nova.print.util.SetupInfo;
	import com.nova.print.view.Page;
	
	import flash.display.Sprite;
	
	import mx.controls.Alert;
	import mx.core.INavigatorContent;
	import mx.core.IUIComponent;
	import mx.core.UIComponent;
	import mx.managers.LayoutManager;
	
	import spark.layouts.supportClasses.LayoutBase;

	public class PrintDoc extends Sprite
	{
		/**
		 * 打印机偏移距离
		 * */
		private var offsetX:int=0;
		private var offsetY:int=0;
		private var rotationSprite:int=0;
		private var rotationArr:Array=[];
		private var localArr:Array=[];
		public function PrintDoc()
		{
			
		}
		public function Creat(_rowCurrentPage:int,_colCurrentPage:int):void
		{
			
		
			var ground:Sprite=new Sprite();
			ground.graphics.clear();
			//ground.graphics.lineStyle(1);
			ground.graphics.beginFill(0xffffff,1);
			ground.graphics.drawRect(0,0,SetupInfo.getInstance().paperRealWidth,SetupInfo.getInstance().paperRealHeight);
			ground.graphics.endFill();
			this.addChild(ground);
			
			offsetX=SetupInfo.getInstance().printLeft;
			offsetY=SetupInfo.getInstance().printTop;
			
			var topX:Number=offsetX;
			var topY:Number=LayoutMap.getSimple().getTopY()+offsetY;
			var gridX:int=offsetX;
			var gridY:int=LayoutMap.getSimple().getGridY()+offsetY;
			var bottomX:Number=offsetX;
			var bottomY:Number=LayoutMap.getSimple().getBottomY()+offsetY;
			var top:PrintText=new PrintText("top",true);
			this.addChild(top);
			top.x=topX;
			top.y=topY;
			var grid:PrintGrids=getPrintGrid(_rowCurrentPage,_colCurrentPage);
			this.addChild(grid);
			grid.x=offsetX;
			grid.y=gridY;
			var bottom:PrintText=new PrintText("bottom",true);
			this.addChild(bottom);
			bottom.x=bottomX;
			bottom.y=grid.getHeight()+gridY;
			
			var header:PrintHeader=new PrintHeader();
			if(SetupInfo.getInstance().hasGrid)
			{
				header.creatHeader(grid.getGridWidth());
				header.x+=offsetX;
			}
			else
			{
				header.creatHeader(SetupInfo.getInstance().paperRealWidth);
			}
			header.y+=offsetY;
			this.addChild(header);
			
			
			var page:PrintPage=new PrintPage();
			page.Creat(_colCurrentPage,grid);
			ground.addChild(page);
			
			
			trace("打印坐标:  "+this.x+"||||"+top.x+"|||"+top.y);
			
		}
		
		private function getPrintGrid(_rowCurrentPage:int,_colCurrentPage:int):PrintGrids
		{
			return new PrintAdvGrid(_rowCurrentPage,_colCurrentPage);
		}
	}
}