package com.nova.print.util
{
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	
	[Bindable]
	public class BindingVO extends EventDispatcher
	{
		public var headName:String;
		public var selected:Boolean;
		public var unique:String;
		public function BindingVO( _headName:String,_selected:Boolean,_unique:String )
		{
			super();
			this.unique=_unique;
			this.headName = _headName;
			this.selected = _selected;
		}
	}
}