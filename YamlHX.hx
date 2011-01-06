import haxe.xml.Fast;
class YamlHX extends Fast
{
	private static inline var LINE_SEPARATOR = "\n";
	
	public function new(input:String)
	{
		var x:Xml = Xml.parse('<?xml-stylesheet type="text/xsl" href="xml2yaml.xsl"?>\n<YamlHX xmlns="tag:yaml.org,2002" xmlns:yaml="tag:yaml.org,2002"></YamlHX>');
		
		var line = 0;
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
		var block = false;
		
		for(l in lines){
			line++;
			
			if(StringTools.trim(l) != "" || block){ // empty line, skip unless part of a block
				
				colon = l.indexOf(":");
				
				// convert left tabs to spaces
				l = tabsToSpaces(l,colon);
				
				// count the spaces
				spaces = countSpaces(l);
				
				// if block
				if(colon < 0){
					if(block){
						value = l;
						// ltrim the leading tabs
						while(indents > 0 && StringTools.startsWith(value,tabbing)){
							value = value.substr(spaces);
						}

						levels[indents].nodeValue += value; // append new line
					}else{
						throw "YAML Syntax error at line: "+line;
					}
				}else{
				  block = false;
					key = l.substr(0,colon);

					// set tabbing if it's unset
					if(tabbing == "" && spaces > 0){
						tabbing = StringTools.rpad(tabbing, " ", spaces);
					}
			
					// set indents
					indents = 0;
					while(spaces > 0 && StringTools.startsWith(key,tabbing)){
						key = key.substr(tabbing.length);
						indents++;
					}
/*          trace(indents);     */
										
					// check for value
					value = StringTools.trim(l.substr(colon+1));
					new_element = Xml.createElement(StringTools.trim(key));
					if(value != ""){
						if(StringTools.trim(value) == "|"){ // multiline block
							block = true;
						}else if(StringTools.startsWith(StringTools.ltrim(value),"&")){ // yaml anchor
						  new_element.set("yaml&#003A;anchor", value.substr(value.indexOf("&")+1));
						}else if(StringTools.startsWith(StringTools.ltrim(value),"*")){ // yaml alias
						  new_element.set("yaml&#003A;alias", value.substr(value.indexOf("*")+1));
						}else{
							new_element.nodeValue = value;
						}
					}
					
					if(spaces > 0){
						levels[indents-1].addChild(new_element);
					}else{
						root.addChild(new_element);
					}
			
					levels[indents] = new_element;
					
				}			
/*				trace(levels);*/
			}
			
		}
		
		super(x);
		
	}
	
	private static inline function tabsToSpaces( s:String, colon:Int ):String
	{
		if(colon < 0){
			return StringTools.replace(s.substr(0),"\t"," ") + LINE_SEPARATOR;
		}else{
			return StringTools.replace(s.substr(0,colon),"\t"," ") + s.substr(colon) + LINE_SEPARATOR;
		}
		
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