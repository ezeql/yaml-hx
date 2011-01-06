/*
	This test should grab read the sample invoice yaml doc from http://yaml.org/xml.html
	and output an accurate xml http://yaml.org/xml/invoice.xml

	then access the yaml variables using the haXe Fast xml wrapper 
	
*/
class Test
{

	public function new()
	{
		var input = 
"number: 34843
date: '2001-01-03'
bill-to: &id001
   given: 'Chris'
   family: Dumars
   address:
 	    lines: |
	       458 Walkman Dr.
	       Suite #292

      city: 'Royal Oak'
      state: MI
      postal: 48046
ship-to: *id001
product: 
   - 
      sku: BL394D
      quantity: 4
      description: Basketball
      price: '450.00'
   - 
      sku: BL4438
      quantity: 1
      description: 'Super Hoop'
      price: '2392.00'";

		var yamlhx = YamlHX.read(input);
		
		var tf = new flash.text.TextField();
		tf.multiline = true;
		tf.width = flash.Lib.current.stage.stageWidth;
		tf.height = flash.Lib.current.stage.stageHeight;
		tf.text = yamlhx.x.toString();
		tf.wordWrap = true;
		flash.Lib.current.stage.addChild(tf);
	}
	public static function main(){
		new Test();
	}
}