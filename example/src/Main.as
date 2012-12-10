package
{
	import com.debokeh.anes.utils.PhotosAlbum;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.JPEGEncoderOptions;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.utils.ByteArray;
	
	public class Main extends Sprite
	{
		[Embed(source="/../assets/DSC07379.JPG")]
		private var _bitmap_clazz:Class;
		private var _bitmapData:BitmapData = Bitmap(new _bitmap_clazz).bitmapData;

		private var _tf:TextField;
		
		public function Main()
		{
			addChild(_tf = new TextField);
			_tf.autoSize = TextFieldAutoSize.LEFT;
			_tf.text = "click me!";
			
			var photosAlbum:PhotosAlbum = new PhotosAlbum();
			
			stage.addEventListener(MouseEvent.CLICK, function():void
			{
				trace("saveToCameraRoll...");
				
				var ba:ByteArray = new ByteArray();
				
				// for PNG
				//_bitmapData.encode(_bitmapData.rect, new PNGEncoderOptions(false), ba);
				
				// for JPG
				_bitmapData.encode(_bitmapData.rect, new JPEGEncoderOptions(100), ba);
				
				// listen to
				photosAlbum.addEventListener(Event.COMPLETE, onSaveImage);
				photosAlbum.addEventListener(IOErrorEvent.IO_ERROR, onSaveImage);
				
				// then save!
				photosAlbum.saveImage(ba);
				
				// dispose
				ba.clear();
				ba = null;
			});
		}
		
		private function onSaveImage(event:Event):void
		{
			trace(event);
			_tf.appendText("\n" + event.toString());
		}
	}
}