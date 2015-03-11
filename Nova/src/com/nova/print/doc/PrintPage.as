package com.nova.print.doc
{
	import com.nova.print.control.NovaText;
	import com.nova.print.util.SetupInfo;
	
	import flash.display.Sprite;

	public class PrintPage extends Sprite
	{
		private var headTxt:NovaText;
		private var footTxt:NovaText;
		private var pageNum:NovaText;
		public function PrintPage()
		{
			
		}
		public  function Creat(_colCurrentPage:int,_grid:PrintGrids):void
		{
			headTxt=new NovaText(SetupInfo.getInstance().printHeader,"center","",SetupInfo.getInstance().getPaperArrays()[0]);
			this.addChild(headTxt);
			footTxt=new NovaText(SetupInfo.getInstance().printFooter,"center","",SetupInfo.getInstance().getPaperArrays()[1]);
			this.addChild(footTxt);
			
			var pageNumTxt:String="";
			if(SetupInfo.getInstance().colPages>1)
			{
				pageNumTxt=(_colCurrentPage+1)+"/"+(SetupInfo.getInstance().colPages);
			}
			
			pageNum=new NovaText(pageNumTxt,"right","",50);
			this.addChild(pageNum);
			headTxt.y=0;
			footTxt.y=SetupInfo.getInstance().getPaperArrays()[1]-SetupInfo.getInstance().printFooterNum-15;
			pageNum.x=_grid.x+_grid.width-35;
			pageNum.y=_grid.y-15;
		}
	}
}