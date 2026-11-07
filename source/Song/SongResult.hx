// import flixel.util.FlxSave;

// class SongResult {
//     // Identity — để ResultState hiển thị + build FlxSave key
//     public var songName:String = "";
//     public var difficulty:String = "";
    
//     // Data (mặc định 0 khi new)
//     public var score:Int = 0;
//     public var accuracy:Float = 0;
//     public var rank:String = "F";
//     public var maxCombo:Int = 0;
//     public var status:String = "fail";
    
//     // Rating counts (PDF yêu cầu Result hiển thị)
//     public var perfect:Int = 0;
//     public var precise:Int = 0;
//     public var tight:Int = 0;
//     public var loose:Int = 0;
//     public var off:Int = 0;
//     public var miss:Int = 0;
    
//     public function new() {}  // trống hoàn toàn
    
//     // PlayState dùng: copy từ PlayerStats
//     public function loadData(stats:PlayerStats):Void {  }
    
//     // PlayState dùng lúc outro: lưu
//     public function saveData(save:FlxSave):Void {  }
    
//     // Menu dùng: load, trả về true nếu có data
//     public function loadData(save:FlxSave, songName:String, difficulty:String):Bool {  }
// }