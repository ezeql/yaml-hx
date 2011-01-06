import haxe.xml.Fast;
class YamlHX extends Fast
{
	private static inline var LINE_SEPARATOR = "\n";
	
	public function new(input:String)
	{
		var x:Xml = Xml.parse('<?xml-stylesheet type="text/xsl" href="xml2yaml.xsl"?>\n<YamlHX xmlns="tag:yaml.org,2002" xmlns:yaml="tag:yaml.org,2002"></YamlHX>');
		
		var lines = input.split(LINE_SEPARATOR);
		var indents = 0; // running
		var spaces = 0; // temp
		var colon = 0;
		var key = "";
		var root = x.firstElement();
		var levels: Array<Xml> = [root]; // level0 is last direct descendant of root
		var value = "";
		var new_element: Xml;
		var tabbing = "";
		
		for(l in lines){
			if(StringTools.trim(l) != ""){ // empty line, skip unless part of a block
				
			
				colon = l.indexOf(":");
				key = l.substr(0,colon);

				// convert left tabs to spaces
				l = StringTools.replace(l.substr(0,colon),"\t"," ") + l.substr(colon) + LINE_SEPARATOR;

				// check for value
				value = StringTools.trim(l.substr(colon+1));
				if(value != ""){
					new_element = Xml.createElement(StringTools.trim(key));
					new_element.nodeValue = value;
				}else{
					new_element = Xml.createElement(StringTools.trim(key));
				}

				// count the spaces
				spaces = countSpaces(l);
/*				trace(spaces);*/
			
				// set tabbing if it's unset
				if(tabbing == "" && spaces > 0){
					tabbing = StringTools.rpad(tabbing, " ", spaces);
				}
			
				// set indents
				indents = 0;
				while(spaces > 0 && StringTools.startsWith(key,tabbing)){
					key = key.substr(spaces);
					indents++;
				}
/*				trace(indents);*/			
			
				if(spaces > 0){
					levels[indents-1].addChild(new_element);
				}else{
					root.addChild(new_element);
				}
			
				if(levels[indents] == null){
					levels.push(new_element);
				}else{
					levels[indents] = new_element;
				}
			
/*				trace(levels);*/
			}
		}
		
		super(x);
		
	}
	
	private static inline function countSpaces( s:String ):Int
	{
		var spaces = 0;
		while(StringTools.isSpace(s,spaces)){
			spaces++;
		}
		return spaces;
	}

	public static function read(input:String):YamlHX
	{
		var yamls = new YamlHX(input);
		return yamls;
	}
	
}