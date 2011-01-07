import haxe.xml.Fast;
class YamlHX extends Fast
{
	private static inline var LINE_SEPARATOR = "\n";
	public var anchors: Hash<Xml>;
	
	public function new(input:String)
	{
	  anchors = new Hash<Xml>();
		var x:Xml = Xml.parse('<?xml version="1.0"?>\n<YamlHX xmlns="tag:yaml.org,2002" xmlns:yaml="tag:yaml.org,2002"></YamlHX>');
		
		var line = 0;
		var lines = input.split(LINE_SEPARATOR);
		var indents = 0;
		var spaces = 0;
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
				
				// set tabbing if it's unset
				if(tabbing == "" && spaces > 0){
					tabbing = StringTools.rpad(tabbing, " ", spaces);
				}
				
				// if block
				if(colon < 0){
					if(block){
						value = l;
						// ltrim the leading tabs
						while(indents > 0 && StringTools.startsWith(value,tabbing)){
							value = value.substr(spaces);
						}

						levels[indents].nodeValue += value; // append new line
					}else if(StringTools.trim(l) == "-"){ // list items
					  new_element = Xml.createElement("_"); // <_>
					  
					  // set indents
  					indents = 0;
  					while(spaces > 0 && StringTools.startsWith(l,tabbing)){
  						l = l.substr(tabbing.length);
  						indents++;
  					}
  					
  					if(spaces > 0){
  						levels[indents-1].addChild(new_element);
  					}else{
  						root.addChild(new_element);
  					}

  					levels[indents] = new_element;
					}else{
						throw "YAML Syntax error at line: "+line;
					}
				}else{
				  block = false;
					key = l.substr(0,colon);
			
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
						  new_element.set("yaml-anchor", value.substr(value.indexOf("&")+1)); // should be yaml:anchor
						  anchors.set(value.substr(value.indexOf("&")+1), new_element);
						}else if(StringTools.startsWith(StringTools.ltrim(value),"*")){ // yaml alias
						  new_element.set("yaml-alias", value.substr(value.indexOf("*")+1)); // should be yaml:alias
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
		
		super(x.firstElement());
		
	}
	
	public inline function get( s:String ):String
	{
	  var f:Fast = this;
	  var value:String;
	  var address = s.split(".");
	  for(v in address){
	    if(f.hasNode.resolve(v)){
	      f = f.node.resolve(v);
	    }else if(StringTools.startsWith(v,"@") && f.has.resolve(v.substr(1))){ // @attribute
	      return f.att.resolve(v);
      }else if(f.has.resolve("yaml-alias") && anchors.exists(f.att.resolve("yaml-alias"))){ // alias?
        var clonee = anchors.get(f.att.resolve("yaml-alias"));
        f = new Fast(clonee).node.resolve(v);
	    }else if(v.indexOf("[") > 0 && v.indexOf("]") > 0){ // array accessor for lists
	      var index = Std.parseInt(v.substr(v.indexOf("[")+1,v.indexOf("]")));
	      var list = f.node.resolve(v.substr(0,v.indexOf("["))).nodes.resolve("_");
        if(list.length > index){
          var i = 0;
          for(item in list){
            if(i == index){
              f = item;
            }else{ i++; }
          }
        }else{
          throw "YamlHX.get() error, node list '"+v+"' index '"+index+"' out of bounds in '"+f.name+"'";
        }
	    }else{
	      throw "YamlHX.get() error, '"+v+"' not found in '"+f.name+"'";
	    }
	  }
	  return f.innerData;
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
#if flash8
  #error
  // Fork this project and fix it if you want it
  // https://github.com/theRemix/yaml-hx
#end
		var yamls = new YamlHX(input);
		return yamls;
	}
	
}