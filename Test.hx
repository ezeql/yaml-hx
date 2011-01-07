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
    var out = "<h3>XML Output</h3><br /><pre>"+StringTools.htmlEscape(yamlhx.x.toString())+"</pre><br />"
    + "\n\n <p><strong>yamlhx.node.tax.name : yamlhx.node.tax.innerData</strong></p><p>\n"+ yamlhx.node.tax.name + " : " + yamlhx.node.tax.innerData + "</p>"
    + "\n\n <p><strong>yamlhx.node.resolve(\"bill-to\").node.given.name : yamlhx.node.resolve(\"bill-to\").node.given.innerData</strong></p><p>  \n"+ yamlhx.node.resolve("bill-to").node.given.name + " : " + yamlhx.node.resolve("bill-to").node.given.innerData + "</p>"
    + "\n\n <p><strong>total : yamlhx.get(\"total\")</strong></p><p>\n"+ yamlhx.get("total") + "</p>"
    + "\n\n <p><strong>city : yamlhx.get(\"ship-to.address.city\")</strong></p><p>\n"+ yamlhx.get("ship-to.address.city") + "</p>"
    + "\n\n <p><strong>second product's description : yamlhx.get(\"product[1].description\")</strong></p><p>\n"+ yamlhx.get("product[1].description") + "</p>";
    
#if flash9
		var tf = new flash.text.TextField();
		tf.multiline = true;
		tf.width = flash.Lib.current.stage.stageWidth;
		tf.height = flash.Lib.current.stage.stageHeight;
		tf.wordWrap = true;
    flash.Lib.current.stage.addChild(tf);
    
    tf.htmlText = out;
#elseif flash8
		var tf = flash.Lib.current.createTextField("tf",1,0,0,750,600);
		tf.multiline = true;
		tf.wordWrap = true;
		tf.html = true;
		tf.htmlText = out;

#elseif js
    js.Lib.document.write(out);
#end  
    
	}
	public static function main(){
		new Test();
	}
}