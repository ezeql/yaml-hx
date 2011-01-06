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
      price: '2392.00'
tax: '251.42'
total: '4443.52'
comments: 'Late afternoon is best. Backup contact is Nancy Billsmer @ 338-4338'";

		var yamlhx = YamlHX.read(input);
		
		var tf = new flash.text.TextField();
		tf.multiline = true;
		tf.width = flash.Lib.current.stage.stageWidth;
		tf.height = flash.Lib.current.stage.stageHeight;
		tf.wordWrap = true;
    flash.Lib.current.stage.addChild(tf);
    
    tf.text = yamlhx.x.toString();
    
    tf.text += "\n\n yamlhx.node.tax.name : yamlhx.node.tax.innerData  \n"+ yamlhx.node.tax.name + " : " + yamlhx.node.tax.innerData;
    tf.text += "\n\n yamlhx.node.resolve(\"bill-to\").node.given.name : yamlhx.node.resolve(\"bill-to\").node.given.innerData  \n"+ yamlhx.node.resolve("bill-to").node.given.name + " : " + yamlhx.node.resolve("bill-to").node.given.innerData;
    tf.text += "\n\n total : yamlhx.get(\"total\")\n"+ yamlhx.get("total");
    tf.text += "\n\n city : yamlhx.get(\"ship-to.address.city\")\n"+ yamlhx.get("ship-to.address.city");
    tf.text += "\n\n second product's description : yamlhx.get(\"product[1].description\")\n"+ yamlhx.get("product[1].description");
	}
	public static function main(){
		new Test();
	}
}