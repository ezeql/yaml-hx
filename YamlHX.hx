import haxe.FastList;
class YamlHX extends Hash<YamlHX>
{
	private static inline var LINE_SEPARATOR = "\n";
	
	public var key: String;
	public var value: String;
	public var yaml: YamlHX;
	public var line: Int;
	public var level: Int;
	public function new(line:Int, level:Int, input:String, ?delimiter:String = "  ")
	{
		this.line = line;
		this.level = level;
		super();
		if(!StringTools.startsWith(input, delimiter)){
			var colon = input.indexOf(":");
			if(colon < 0) throw "Syntax error at line: "+line+" . missing colon :";
			
			var val = input.substr(colon);
			if(StringTools.rtrim(val) == ""){ // empty or is a branch
				// read all child lines
				var child_lines = YamlHX.findChildren(input.substr(input.indexOf(LINE_SEPARATOR)));
				trace(child_lines);
			}else{ // is a leaf
/*				set(input.substr(0, colon), input.substr(colon));*/
				value = input.substr(colon);
			}
		}
		
	}

	public static function read(input:String, ?delimiter:String = "  ", ?level:Int = 0):YamlHX
	{
		var yamls = new YamlHX(1, level, input, delimiter);
		return yamls;
	}
	
	public static function findChildren(input:String):FastList<String>
	{
		return new FastList<String>();
	}
}