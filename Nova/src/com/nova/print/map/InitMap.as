package com.nova.print.map
{
/**
 * 此类做所有初始化的工作
 * 1：获取固定列和变动列的数字
 * 
 * */
	import com.nova.print.util.SetupInfo;

	public class InitMap
	{
		
		private static var _simple:InitMap=null;
		public static function getSimple():InitMap
		{
			if(_simple==null)
			{
				_simple=new InitMap();
			}
			return _simple;
		}
/**
 * 折页的时候 计算第一页的列数  和   第二页的列数 
 * 或者固定列 和变动列
 *   */
		public function indexFirstEndRows():void
		{
			var fixBol:Boolean=SetupInfo.getInstance().printFixChangeBol;
			var gridType:int=LayoutMap.getSimple().gridType;
			var allColumnNum:int=LayoutMap.getSimple().allColumnIndex;
			if(fixBol)
			{
				SetupInfo.getInstance().printEndRow=allColumnNum-1;
			}
			else
			{
				if(allColumnNum>=4)
				{
					SetupInfo.getInstance().printFirstRow=4;
				}
				else
				{
					SetupInfo.getInstance().printFirstRow=allColumnNum-1;
				}
			}
		}
	}
}