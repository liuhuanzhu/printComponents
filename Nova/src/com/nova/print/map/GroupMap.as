package com.nova.print.map
{
	public class GroupMap
	{
		private static var _simple:GroupMap=null;
		private var _parentHeader:String;
		private var _unique:String;
		private var _letterSpac:int=0;
		private var _sonHeaderArray:Array=null;
		private var _sonFieldArray:Array=null;
		private var _sonAlginArray:Array=null;
		private var _letterSpacArr:Array=null;
		private var _isGroup:Boolean=false;
		public static function getSimple():GroupMap
		{
			if(_simple==null)
			{
				_simple=new GroupMap();
			}
			return _simple;
		}
		public function insertParentHeader(parentHeader:String):void
		{
			this._parentHeader=parentHeader;
		}
		public function insertIsGroup(group:String):void
		{
			if(group=="0")
			{
				this._isGroup=false;
			}
			else
			{
				this._isGroup=true;
			}
		}
		public function insertSonHeader(sonArr:Array):void
		{
			if(_sonHeaderArray==null)
			{
				_sonHeaderArray=[];
				_sonFieldArray=[];
				_sonAlginArray=[];
				_letterSpacArr=[];
			}
			_sonHeaderArray.push(sonArr[1]);
			_sonFieldArray.push(sonArr[2]);
			_sonAlginArray.push(sonArr[3]);
			_letterSpacArr.push(sonArr[7]);
		}
/**
 * 每一个父Header下的子Header
 * */
		public function get sonHeaderArray():Array
		{
			return _sonHeaderArray;
		}

		public function set sonHeaderArray(value:Array):void
		{
			_sonHeaderArray = value;
		}

		public function get parentHeader():String
		{
			return _parentHeader;
		}

		public function set parentHeader(value:String):void
		{
			_parentHeader = value;
		}

		public function get isGroup():Boolean
		{
			return _isGroup;
		}

		public function set isGroup(value:Boolean):void
		{
			_isGroup = value;
		}

		public function get sonFieldArray():Array
		{
			return _sonFieldArray;
		}

		public function set sonFieldArray(value:Array):void
		{
			_sonFieldArray = value;
		}

		public function get sonAlginArray():Array
		{
			return _sonAlginArray;
		}

		public function set sonAlginArray(value:Array):void
		{
			_sonAlginArray = value;
		}
/**
 * 每一顶级列的唯一标识
 * */
		public function get unique():String
		{
			return _unique;
		}

		public function set unique(value:String):void
		{
			_unique = value;
		}

		public function get letterSpac():int
		{
			return _letterSpac;
		}

		public function set letterSpac(value:int):void
		{
			_letterSpac = value;
		}

		public function get letterSpacArr():Array
		{
			return _letterSpacArr;
		}

		public function set letterSpacArr(value:Array):void
		{
			_letterSpacArr = value;
		}


	}
}