package com.debokeh.anes.utils
{
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.utils.ByteArray;

	public class PhotosAlbum extends EventDispatcher
	{
		private var _context:ExtensionContext;

		public function PhotosAlbum()
		{
			_context = ExtensionContext.createExtensionContext("com.debokeh.anes.utils.PhotosAlbum", null);
			_context.addEventListener(StatusEvent.STATUS, onStatus);
		}

		private function onStatus(event:StatusEvent):void
		{
			trace("event:" + event);

			switch(event.code) {
				case Event.COMPLETE:
					dispatchEvent(new Event(Event.COMPLETE));
				break;
				case ErrorEvent.ERROR:
					dispatchEvent(new ErrorEvent(ErrorEvent.ERROR));
				break;
			}
		}

		public function saveImage(ba:ByteArray):void
		{
			_context.call('saveImage', ba);
		}

		public function dispose():void
		{
			if(_context)
			{
				_context.dispose();
				_context = null;
			}
		}
	}
}
