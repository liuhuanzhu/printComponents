package com.nova.print.event
{
	import flash.events.Event;

	public class PrintEvents extends Event
	{
		
		/**
		 * 打印属性发生改变
		 * */
		public static const PrintChange:String="print_change";
		
		public var info:*=null;
		
		public function PrintEvents(eventname:String,_info:*=null)
		{
			super(eventname);
			info=_info;
		}
	}
}