class Test
{

	public function new()
	{
		var input = 
"test1: blah
test2: bloo
test3:
	tier2_1: whoo
	tier2_2: whee
	tier2_3:
		tier3_1: enough
	tier2_4: waddaa
test4: finished";
		var hash = YamlHX.read(input);
		trace(hash);
	}
	public static function main(){
		new Test();
	}
}