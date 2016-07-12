﻿//Created by Action Script Viewer - http://www.buraks.com/asv
package com.adobe.net {

    public class URI {

        protected var _valid:Boolean;// = false
        protected var _relative:Boolean;// = false
        protected var _scheme:String;// = ""
        protected var _authority:String;// = ""
        protected var _username:String;// = ""
        protected var _password:String;// = ""
        protected var _port:String;// = ""
        protected var _path:String;// = ""
        protected var _query:String;// = ""
        protected var _fragment:String;// = ""
        protected var _nonHierarchical:String;// = ""

        public static const URImustEscape:String = " %";
        public static const URIbaselineEscape:String = (URImustEscape + ":?#/@");
        public static const URIpathEscape:String = (URImustEscape + "?#");
        public static const URIqueryEscape:String = (URImustEscape + "#");
        public static const URIqueryPartEscape:String = (URImustEscape + "#&=");
        public static const URInonHierEscape:String = (URImustEscape + "?#/");
        public static const UNKNOWN_SCHEME:String = "unknown";
        protected static const URIbaselineExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(URIbaselineEscape);
        protected static const URIschemeExcludedBitmap:URIEncodingBitmap = URIbaselineExcludedBitmap;
        protected static const URIuserpassExcludedBitmap:URIEncodingBitmap = URIbaselineExcludedBitmap;
        protected static const URIauthorityExcludedBitmap:URIEncodingBitmap = URIbaselineExcludedBitmap;
        protected static const URIportExludedBitmap:URIEncodingBitmap = URIbaselineExcludedBitmap;
        protected static const URIpathExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(URIpathEscape);
        protected static const URIqueryExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(URIqueryEscape);
        protected static const URIqueryPartExcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(URIqueryPartEscape);
        protected static const URIfragmentExcludedBitmap:URIEncodingBitmap = URIqueryExcludedBitmap;
        protected static const URInonHierexcludedBitmap:URIEncodingBitmap = new URIEncodingBitmap(URInonHierEscape);
        public static const NOT_RELATED:int = 0;
        public static const CHILD:int = 1;
        public static const EQUAL:int = 2;
        public static const PARENT:int = 3;

        protected static var _resolver:IURIResolver = null;

        public function URI(uri:String=null):void{
            super();
            if (uri == null){
                this.initialize();
            } else {
                this.constructURI(uri);
            };
        }
        protected function constructURI(uri:String):Boolean{
            if (!(this.parseURI(uri))){
                this._valid = false;
            };
            return (this.isValid());
        }
        protected function initialize():void{
            this._valid = false;
            this._relative = false;
            this._scheme = UNKNOWN_SCHEME;
            this._authority = "";
            this._username = "";
            this._password = "";
            this._port = "";
            this._path = "";
            this._query = "";
            this._fragment = "";
            this._nonHierarchical = "";
        }
        protected function set hierState(state:Boolean):void{
            if (state){
                this._nonHierarchical = "";
                if ((((this._scheme == "")) || ((this._scheme == UNKNOWN_SCHEME)))){
                    this._relative = true;
                } else {
                    this._relative = false;
                };
                if ((((this._authority.length == 0)) && ((this._path.length == 0)))){
                    this._valid = false;
                } else {
                    this._valid = true;
                };
            } else {
                this._authority = "";
                this._username = "";
                this._password = "";
                this._port = "";
                this._path = "";
                this._relative = false;
                if ((((this._scheme == "")) || ((this._scheme == UNKNOWN_SCHEME)))){
                    this._valid = false;
                } else {
                    this._valid = true;
                };
            };
        }
        protected function get hierState():Boolean{
            return ((this._nonHierarchical.length == 0));
        }
        protected function validateURI():Boolean{
            if (this.isAbsolute()){
                if ((((this._scheme.length <= 1)) || ((this._scheme == UNKNOWN_SCHEME)))){
                    return (false);
                };
                if (this.verifyAlpha(this._scheme) == false){
                    return (false);
                };
            };
            if (this.hierState){
                if (this._path.search("\\") != -1){
                    return (false);
                };
                if ((((this.isRelative() == false)) && ((this._scheme == UNKNOWN_SCHEME)))){
                    return (false);
                };
            } else {
                if (this._nonHierarchical.search("\\") != -1){
                    return (false);
                };
            };
            return (true);
        }
        protected function parseURI(uri:String):Boolean{
            var index:int;
            var index2:int;
            var baseURI:String = uri;
            this.initialize();
            index = baseURI.indexOf("#");
            if (index != -1){
                if (baseURI.length > (index + 1)){
                    this._fragment = baseURI.substr((index + 1), (baseURI.length - (index + 1)));
                };
                baseURI = baseURI.substr(0, index);
            };
            index = baseURI.indexOf("?");
            if (index != -1){
                if (baseURI.length > (index + 1)){
                    this._query = baseURI.substr((index + 1), (baseURI.length - (index + 1)));
                };
                baseURI = baseURI.substr(0, index);
            };
            index = baseURI.search(":");
            index2 = baseURI.search("/");
            var containsColon:Boolean = !((index == -1));
            var containsSlash:Boolean = !((index2 == -1));
            var colonBeforeSlash:Boolean = ((!(containsSlash)) || ((index < index2)));
            if (((containsColon) && (colonBeforeSlash))){
                this._scheme = baseURI.substr(0, index);
                this._scheme = this._scheme.toLowerCase();
                baseURI = baseURI.substr((index + 1));
                if (baseURI.substr(0, 2) == "//"){
                    this._nonHierarchical = "";
                    baseURI = baseURI.substr(2, (baseURI.length - 2));
                } else {
                    this._nonHierarchical = baseURI;
                    if ((this._valid = this.validateURI()) == false){
                        this.initialize();
                    };
                    return (this.isValid());
                };
            } else {
                this._scheme = "";
                this._relative = true;
                this._nonHierarchical = "";
            };
            if (this.isRelative()){
                this._authority = "";
                this._port = "";
                this._path = baseURI;
            } else {
                if (baseURI.substr(0, 2) == "//"){
                    while (baseURI.charAt(0) == "/") {
                        baseURI = baseURI.substr(1, (baseURI.length - 1));
                    };
                };
                index = baseURI.search("/");
                if (index == -1){
                    this._authority = baseURI;
                    this._path = "";
                } else {
                    this._authority = baseURI.substr(0, index);
                    this._path = baseURI.substr(index, (baseURI.length - index));
                };
                index = this._authority.search("@");
                if (index != -1){
                    this._username = this._authority.substr(0, index);
                    this._authority = this._authority.substr((index + 1));
                    index = this._username.search(":");
                    if (index != -1){
                        this._password = this._username.substring((index + 1), this._username.length);
                        this._username = this._username.substr(0, index);
                    } else {
                        this._password = "";
                    };
                } else {
                    this._username = "";
                    this._password = "";
                };
                index = this._authority.search(":");
                if (index != -1){
                    this._port = this._authority.substring((index + 1), this._authority.length);
                    this._authority = this._authority.substr(0, index);
                } else {
                    this._port = "";
                };
                this._authority = this._authority.toLowerCase();
            };
            if ((this._valid = this.validateURI()) == false){
                this.initialize();
            };
            return (this.isValid());
        }
        public function copyURI(uri:URI):void{
            this._scheme = uri._scheme;
            this._authority = uri._authority;
            this._username = uri._username;
            this._password = uri._password;
            this._port = uri._port;
            this._path = uri._path;
            this._query = uri._query;
            this._fragment = uri._fragment;
            this._nonHierarchical = uri._nonHierarchical;
            this._valid = uri._valid;
            this._relative = uri._relative;
        }
        protected function verifyAlpha(str:String):Boolean{
            var index:int;
            var pattern:RegExp = /[^a-z]/;
            str = str.toLowerCase();
            index = str.search(pattern);
            if (index == -1){
                return (true);
            };
            return (false);
        }
        public function isValid():Boolean{
            return (this._valid);
        }
        public function isAbsolute():Boolean{
            return (!(this._relative));
        }
        public function isRelative():Boolean{
            return (this._relative);
        }
        public function isDirectory():Boolean{
            if (this._path.length == 0){
                return (false);
            };
            return ((this._path.charAt((this.path.length - 1)) == "/"));
        }
        public function isHierarchical():Boolean{
            return (this.hierState);
        }
        public function get scheme():String{
            return (URI.unescapeChars(this._scheme));
        }
        public function set scheme(schemeStr:String):void{
            var normalized:String = schemeStr.toLowerCase();
            this._scheme = URI.fastEscapeChars(normalized, URI.URIschemeExcludedBitmap);
        }
        public function get authority():String{
            return (URI.unescapeChars(this._authority));
        }
        public function set authority(authorityStr:String):void{
            authorityStr = authorityStr.toLowerCase();
            this._authority = URI.fastEscapeChars(authorityStr, URI.URIauthorityExcludedBitmap);
            this.hierState = true;
        }
        public function get username():String{
            return (URI.unescapeChars(this._username));
        }
        public function set username(usernameStr:String):void{
            this._username = URI.fastEscapeChars(usernameStr, URI.URIuserpassExcludedBitmap);
            this.hierState = true;
        }
        public function get password():String{
            return (URI.unescapeChars(this._password));
        }
        public function set password(passwordStr:String):void{
            this._password = URI.fastEscapeChars(passwordStr, URI.URIuserpassExcludedBitmap);
            this.hierState = true;
        }
        public function get port():String{
            return (URI.unescapeChars(this._port));
        }
        public function set port(portStr:String):void{
            this._port = URI.escapeChars(portStr);
            this.hierState = true;
        }
        public function get path():String{
            return (URI.unescapeChars(this._path));
        }
        public function set path(pathStr:String):void{
            this._path = URI.fastEscapeChars(pathStr, URI.URIpathExcludedBitmap);
            if (this._scheme == UNKNOWN_SCHEME){
                this._scheme = "";
            };
            this.hierState = true;
        }
        public function get query():String{
            return (URI.unescapeChars(this._query));
        }
        public function set query(queryStr:String):void{
            this._query = URI.fastEscapeChars(queryStr, URI.URIqueryExcludedBitmap);
        }
        public function get queryRaw():String{
            return (this._query);
        }
        public function set queryRaw(queryStr:String):void{
            this._query = queryStr;
        }
        public function get fragment():String{
            return (URI.unescapeChars(this._fragment));
        }
        public function set fragment(fragmentStr:String):void{
            this._fragment = URI.fastEscapeChars(fragmentStr, URIfragmentExcludedBitmap);
        }
        public function get nonHierarchical():String{
            return (URI.unescapeChars(this._nonHierarchical));
        }
        public function set nonHierarchical(nonHier:String):void{
            this._nonHierarchical = URI.fastEscapeChars(nonHier, URInonHierexcludedBitmap);
            this.hierState = false;
        }
        public function setParts(schemeStr:String, authorityStr:String, portStr:String, pathStr:String, queryStr:String, fragmentStr:String):void{
            this.scheme = schemeStr;
            this.authority = authorityStr;
            this.port = portStr;
            this.path = pathStr;
            this.query = queryStr;
            this.fragment = fragmentStr;
            this.hierState = true;
        }
        public function isOfType(scheme:String):Boolean{
            scheme = scheme.toLowerCase();
            return ((this._scheme == scheme));
        }
        public function getQueryValue(name:String):String{
            var map:Object;
            var item:String;
            var value:String;
            map = this.getQueryByMap();
            for (item in map) {
                if (item == name){
                    value = map[item];
                    return (value);
                };
            };
            return (new String(""));
        }
        public function setQueryValue(name:String, value:String):void{
            var map:Object;
            map = this.getQueryByMap();
            map[name] = value;
            this.setQueryByMap(map);
        }
        public function getQueryByMap():Object{
            var queryStr:String;
            var pair:String;
            var pairs:Array;
            var item:Array;
            var name:String;
            var value:String;
            var index:int;
            var map:Object = new Object();
            queryStr = this._query;
            pairs = queryStr.split("&");
            for each (pair in pairs) {
                if (pair.length == 0){
                } else {
                    item = pair.split("=");
                    if (item.length > 0){
                        name = item[0];
                    } else {
                        //unresolved jump
                    };
                    if (item.length > 1){
                        value = item[1];
                    } else {
                        value = "";
                    };
                    name = queryPartUnescape(name);
                    value = queryPartUnescape(value);
                    map[name] = value;
                };
            };
            return (map);
        }
        public function setQueryByMap(map:Object):void{
            var item:String;
            var name:String;
            var value:String;
            var tmpPair:String;
            var foo:String;
            var queryStr:String = "";
            for (item in map) {
                name = item;
                value = map[item];
                if (value == null){
                    value = "";
                };
                name = queryPartEscape(name);
                value = queryPartEscape(value);
                tmpPair = name;
                if (value.length > 0){
                    tmpPair = (tmpPair + "=");
                    tmpPair = (tmpPair + value);
                };
                if (queryStr.length != 0){
                    queryStr = (queryStr + "&");
                };
                queryStr = (queryStr + tmpPair);
            };
            this._query = queryStr;
        }
        public function toString():String{
            if (this == null){
                return ("");
            };
            return (this.toStringInternal(false));
        }
        public function toDisplayString():String{
            return (this.toStringInternal(true));
        }
        protected function toStringInternal(forDisplay:Boolean):String{
            var uri:String = "";
            var part:String = "";
            if (this.isHierarchical() == false){
                uri = (uri + (forDisplay) ? this.scheme : this._scheme);
                uri = (uri + ":");
                uri = (uri + (forDisplay) ? this.nonHierarchical : this._nonHierarchical);
            } else {
                if (this.isRelative() == false){
                    if (this._scheme.length != 0){
                        part = (forDisplay) ? this.scheme : this._scheme;
                        uri = (uri + (part + ":"));
                    };
                    if (((!((this._authority.length == 0))) || (this.isOfType("file")))){
                        uri = (uri + "//");
                        if (this._username.length != 0){
                            part = (forDisplay) ? this.username : this._username;
                            uri = (uri + part);
                            if (this._password.length != 0){
                                part = (forDisplay) ? this.password : this._password;
                                uri = (uri + (":" + part));
                            };
                            uri = (uri + "@");
                        };
                        part = (forDisplay) ? this.authority : this._authority;
                        uri = (uri + part);
                        if (this.port.length != 0){
                            uri = (uri + (":" + this.port));
                        };
                    };
                };
                part = (forDisplay) ? this.path : this._path;
                uri = (uri + part);
            };
            if (this._query.length != 0){
                part = (forDisplay) ? this.query : this._query;
                uri = (uri + ("?" + part));
            };
            if (this.fragment.length != 0){
                part = (forDisplay) ? this.fragment : this._fragment;
                uri = (uri + ("#" + part));
            };
            return (uri);
        }
        public function forceEscape():void{
            this.scheme = this.scheme;
            this.setQueryByMap(this.getQueryByMap());
            this.fragment = this.fragment;
            if (this.isHierarchical()){
                this.authority = this.authority;
                this.path = this.path;
                this.port = this.port;
                this.username = this.username;
                this.password = this.password;
            } else {
                this.nonHierarchical = this.nonHierarchical;
            };
        }
        public function isOfFileType(extension:String):Boolean{
            var thisExtension:String;
            var index:int;
            index = extension.lastIndexOf(".");
            if (index != -1){
                extension = extension.substr((index + 1));
            };
            thisExtension = this.getExtension(true);
            if (thisExtension == ""){
                return (false);
            };
            if (compareStr(thisExtension, extension, false) == 0){
                return (true);
            };
            return (false);
        }
        public function getExtension(minusDot:Boolean=false):String{
            var extension:String;
            var index:int;
            var filename:String = this.getFilename();
            if (filename == ""){
                return (String(""));
            };
            index = filename.lastIndexOf(".");
            if ((((index == -1)) || ((index == 0)))){
                return (String(""));
            };
            extension = filename.substr(index);
            if (((minusDot) && ((extension.charAt(0) == ".")))){
                extension = extension.substr(1);
            };
            return (extension);
        }
        public function getFilename(minusExtension:Boolean=false):String{
            var filename:String;
            var index:int;
            if (this.isDirectory()){
                return (String(""));
            };
            var pathStr:String = this.path;
            index = pathStr.lastIndexOf("/");
            if (index != -1){
                filename = pathStr.substr((index + 1));
            } else {
                filename = pathStr;
            };
            if (minusExtension){
                index = filename.lastIndexOf(".");
                if (index != -1){
                    filename = filename.substr(0, index);
                };
            };
            return (filename);
        }
        public function getDefaultPort():String{
            if (this._scheme == "http"){
                return (String("80"));
            };
            if (this._scheme == "ftp"){
                return (String("21"));
            };
            if (this._scheme == "file"){
                return (String(""));
            };
            if (this._scheme == "sftp"){
                return (String("22"));
            };
            return (String(""));
        }
        public function getRelation(uri:URI, caseSensitive:Boolean=true):int{
            var thisParts:Array;
            var thatParts:Array;
            var thisPart:String;
            var thatPart:String;
            var i:int;
            var thisURI:URI = URI.resolve(this);
            var thatURI:URI = URI.resolve(uri);
            if (((thisURI.isRelative()) || (thatURI.isRelative()))){
                return (URI.NOT_RELATED);
            };
            if ((((thisURI.isHierarchical() == false)) || ((thatURI.isHierarchical() == false)))){
                if ((((((thisURI.isHierarchical() == false)) && ((thatURI.isHierarchical() == true)))) || ((((thisURI.isHierarchical() == true)) && ((thatURI.isHierarchical() == false)))))){
                    return (URI.NOT_RELATED);
                };
                if (thisURI.scheme != thatURI.scheme){
                    return (URI.NOT_RELATED);
                };
                if (thisURI.nonHierarchical != thatURI.nonHierarchical){
                    return (URI.NOT_RELATED);
                };
                return (URI.EQUAL);
            };
            if (thisURI.scheme != thatURI.scheme){
                return (URI.NOT_RELATED);
            };
            if (thisURI.authority != thatURI.authority){
                return (URI.NOT_RELATED);
            };
            var thisPort:String = thisURI.port;
            var thatPort:String = thatURI.port;
            if (thisPort == ""){
                thisPort = thisURI.getDefaultPort();
            };
            if (thatPort == ""){
                thatPort = thatURI.getDefaultPort();
            };
            if (thisPort != thatPort){
                return (URI.NOT_RELATED);
            };
            if (compareStr(thisURI.path, thatURI.path, caseSensitive)){
                return (URI.EQUAL);
            };
            var thisPath:String = thisURI.path;
            var thatPath:String = thatURI.path;
            if ((((((thisPath == "/")) || ((thatPath == "/")))) && ((((thisPath == "")) || ((thatPath == "")))))){
                return (URI.EQUAL);
            };
            thisParts = thisPath.split("/");
            thatParts = thatPath.split("/");
            if (thisParts.length > thatParts.length){
                thatPart = thatParts[(thatParts.length - 1)];
                if (thatPart.length > 0){
                    return (URI.NOT_RELATED);
                };
                thatParts.pop();
                i = 0;
                while (i < thatParts.length) {
                    thisPart = thisParts[i];
                    thatPart = thatParts[i];
                    if (compareStr(thisPart, thatPart, caseSensitive) == false){
                        return (URI.NOT_RELATED);
                    };
                    i++;
                };
                return (URI.CHILD);
                //unresolved jump
            };
            if (thisParts.length < thatParts.length){
                thisPart = thisParts[(thisParts.length - 1)];
                if (thisPart.length > 0){
                    return (URI.NOT_RELATED);
                };
                thisParts.pop();
                i = 0;
                while (i < thisParts.length) {
                    thisPart = thisParts[i];
                    thatPart = thatParts[i];
                    if (compareStr(thisPart, thatPart, caseSensitive) == false){
                        return (URI.NOT_RELATED);
                    };
                    i++;
                };
                return (URI.PARENT);
                //unresolved jump
            };
            return (URI.NOT_RELATED);
        }
        public function getCommonParent(uri:URI, caseSensitive:Boolean=true):URI{
            var strBefore:String;
            var strAfter:String;
            var thisURI:URI = URI.resolve(this);
            var thatURI:URI = URI.resolve(uri);
            if (((((((!(thisURI.isAbsolute())) || (!(thatURI.isAbsolute())))) || ((thisURI.isHierarchical() == false)))) || ((thatURI.isHierarchical() == false)))){
                return (null);
            };
            var relation:int = thisURI.getRelation(thatURI);
            if (relation == URI.NOT_RELATED){
                return (null);
            };
            thisURI.chdir(".");
            thatURI.chdir(".");
            do  {
                relation = thisURI.getRelation(thatURI, caseSensitive);
            } while (!((((relation == URI.EQUAL)) || ((relation == URI.PARENT)))));
            return (thisURI);
        }
        public function chdir(reference:String, escape:Boolean=false):Boolean{
            var uriReference:URI;
            var thisPath:String;
            var thatPath:String;
            var thisParts:Array;
            var thatParts:Array;
            var curDir:String;
            var i:int;
            var final:String;
            var ref:String = reference;
            if (escape){
                ref = URI.escapeChars(reference);
            };
            if (ref == ""){
                return (true);
            };
            if (ref.substr(0, 2) == "//"){
                final = ((this.scheme + ":") + ref);
                return (this.constructURI(final));
            };
            if (ref.charAt(0) == "?"){
                ref = ("./" + ref);
            };
            uriReference = new URI(ref);
            if (((uriReference.isAbsolute()) || ((uriReference.isHierarchical() == false)))){
                this.copyURI(uriReference);
                return (true);
            };
            var thisIsDir:Boolean;
            var thatIsDir:Boolean;
            var thisIsAbs:Boolean;
            var thatIsAbs:Boolean;
            var lastIsDotOperation:Boolean;
            thisPath = this.path;
            thatPath = uriReference.path;
            if (thisPath.length > 0){
                thisParts = thisPath.split("/");
            } else {
                thisParts = new Array();
            };
            if (thatPath.length > 0){
                thatParts = thatPath.split("/");
            } else {
                thatParts = new Array();
            };
            if ((((thisParts.length > 0)) && ((thisParts[0] == "")))){
                thisIsAbs = true;
                thisParts.shift();
            };
            if ((((thisParts.length > 0)) && ((thisParts[(thisParts.length - 1)] == "")))){
                thisIsDir = true;
                thisParts.pop();
            };
            if ((((thatParts.length > 0)) && ((thatParts[0] == "")))){
                thatIsAbs = true;
                thatParts.shift();
            };
            if ((((thatParts.length > 0)) && ((thatParts[(thatParts.length - 1)] == "")))){
                thatIsDir = true;
                thatParts.pop();
            };
            if (thatIsAbs){
                this.path = uriReference.path;
                this.queryRaw = uriReference.queryRaw;
                this.fragment = uriReference.fragment;
                return (true);
            };
            if ((((thatParts.length == 0)) && ((uriReference.query == "")))){
                this.fragment = uriReference.fragment;
                return (true);
            };
            if ((((thisIsDir == false)) && ((thisParts.length > 0)))){
                thisParts.pop();
            };
            this.queryRaw = uriReference.queryRaw;
            this.fragment = uriReference.fragment;
            thisParts = thisParts.concat(thatParts);
            i = 0;
            while (i < thisParts.length) {
                curDir = thisParts[i];
                lastIsDotOperation = false;
                if (curDir == "."){
                    thisParts.splice(i, 1);
                    i = (i - 1);
                    lastIsDotOperation = true;
                } else {
                    if (curDir == ".."){
                        if (i >= 1){
                            if (thisParts[(i - 1)] == ".."){
                            } else {
                                thisParts.splice((i - 1), 2);
                                i = (i - 2);
                            };
                        } else {
                            if (this.isRelative()){
                            } else {
                                thisParts.splice(i, 1);
                                i = (i - 1);
                            };
                        };
                        lastIsDotOperation = true;
                    };
                };
                i++;
            };
            var finalPath:String = "";
            thatIsDir = ((thatIsDir) || (lastIsDotOperation));
            finalPath = this.joinPath(thisParts, thisIsAbs, thatIsDir);
            this.path = finalPath;
            return (true);
        }
        protected function joinPath(parts:Array, isAbs:Boolean, isDir:Boolean):String{
            var i:int;
            var pathStr:String = "";
            i = 0;
            while (i < parts.length) {
                if (pathStr.length > 0){
                    pathStr = (pathStr + "/");
                };
                pathStr = (pathStr + parts[i]);
                i++;
            };
            if (((isDir) && ((pathStr.length > 0)))){
                pathStr = (pathStr + "/");
            };
            if (isAbs){
                pathStr = ("/" + pathStr);
            };
            return (pathStr);
        }
        public function makeAbsoluteURI(base_uri:URI):Boolean{
            if (((this.isAbsolute()) || (base_uri.isRelative()))){
                return (false);
            };
            var base:URI = new URI();
            base.copyURI(base_uri);
            if (base.chdir(this.toString()) == false){
                return (false);
            };
            this.copyURI(base);
            return (true);
        }
        public function makeRelativeURI(base_uri:URI, caseSensitive:Boolean=true):Boolean{
            var thisParts:Array;
            var thatParts:Array;
            var thisPart:String;
            var thatPart:String;
            var finalPath:String;
            var i:int;
            var base:URI = new URI();
            base.copyURI(base_uri);
            var finalParts:Array = new Array();
            var pathStr:String = this.path;
            var queryStr:String = this.queryRaw;
            var fragmentStr:String = this.fragment;
            var diff:Boolean;
            var isDir:Boolean;
            if (this.isRelative()){
                return (true);
            };
            if (base.isRelative()){
                return (false);
            };
            if ((((this.isOfType(base_uri.scheme) == false)) || (!((this.authority == base_uri.authority))))){
                return (false);
            };
            isDir = this.isDirectory();
            base.chdir(".");
            thisParts = pathStr.split("/");
            thatParts = base.path.split("/");
            if ((((thisParts.length > 0)) && ((thisParts[0] == "")))){
                thisParts.shift();
            };
            if ((((thisParts.length > 0)) && ((thisParts[(thisParts.length - 1)] == "")))){
                isDir = true;
                thisParts.pop();
            };
            if ((((thatParts.length > 0)) && ((thatParts[0] == "")))){
                thatParts.shift();
            };
            if ((((thatParts.length > 0)) && ((thatParts[(thatParts.length - 1)] == "")))){
                thatParts.pop();
            };
            while (thatParts.length > 0) {
                if (thisParts.length == 0){
                    break;
                };
                thisPart = thisParts[0];
                thatPart = thatParts[0];
                if (compareStr(thisPart, thatPart, caseSensitive)){
                    thisParts.shift();
                    thatParts.shift();
                } else {
                    break;
                };
            };
            var dotdot:String = "..";
            i = 0;
            while (i < thatParts.length) {
                finalParts.push(dotdot);
                i++;
            };
            finalParts = finalParts.concat(thisParts);
            finalPath = this.joinPath(finalParts, false, isDir);
            if (finalPath.length == 0){
                finalPath = "./";
            };
            this.setParts("", "", "", finalPath, queryStr, fragmentStr);
            return (true);
        }
        public function unknownToURI(unknown:String, defaultScheme:String="http"):Boolean{
            var temp:String;
            var path:String;
            if (unknown.length == 0){
                this.initialize();
                return (false);
            };
            unknown = unknown.replace(/\\/g, "/");
            if (unknown.length >= 2){
                temp = unknown.substr(0, 2);
                if (temp == "//"){
                    unknown = ((defaultScheme + ":") + unknown);
                };
            };
            if (unknown.length >= 3){
                temp = unknown.substr(0, 3);
                if (temp == "://"){
                    unknown = (defaultScheme + unknown);
                };
            };
            var uri:URI = new URI(unknown);
            if (uri.isHierarchical() == false){
                if (uri.scheme == UNKNOWN_SCHEME){
                    this.initialize();
                    return (false);
                };
                this.copyURI(uri);
                this.forceEscape();
                return (true);
            } else {
                if (((!((uri.scheme == UNKNOWN_SCHEME))) && ((uri.scheme.length > 0)))){
                    if ((((uri.authority.length > 0)) || ((uri.scheme == "file")))){
                        this.copyURI(uri);
                        this.forceEscape();
                        return (true);
                    };
                    if ((((uri.authority.length == 0)) && ((uri.path.length == 0)))){
                        this.setParts(uri.scheme, "", "", "", "", "");
                        return (false);
                    };
                } else {
                    path = uri.path;
                    if ((((((((path == "..")) || ((path == ".")))) || ((((path.length >= 3)) && ((path.substr(0, 3) == "../")))))) || ((((path.length >= 2)) && ((path.substr(0, 2) == "./")))))){
                        this.copyURI(uri);
                        this.forceEscape();
                        return (true);
                    };
                };
            };
            uri = new URI(((defaultScheme + "://") + unknown));
            if ((((uri.scheme.length > 0)) && ((uri.authority.length > 0)))){
                this.copyURI(uri);
                this.forceEscape();
                return (true);
            };
            this.initialize();
            return (false);
        }

        public static function escapeChars(unescaped:String):String{
            return (fastEscapeChars(unescaped, URI.URIbaselineExcludedBitmap));
        }
        public static function unescapeChars(escaped:String):String{
            var unescaped:String;
            unescaped = decodeURIComponent(escaped);
            return (unescaped);
        }
        public static function fastEscapeChars(unescaped:String, bitmap:URIEncodingBitmap):String{
            var c:String;
            var x:int;
            var i:int;
            var escaped:String = "";
            i = 0;
            while (i < unescaped.length) {
                c = unescaped.charAt(i);
                x = bitmap.ShouldEscape(c);
                if (x){
                    c = x.toString(16);
                    if (c.length == 1){
                        c = ("0" + c);
                    };
                    c = ("%" + c);
                    c = c.toUpperCase();
                };
                escaped = (escaped + c);
                i++;
            };
            return (escaped);
        }
        public static function queryPartEscape(unescaped:String):String{
            var escaped:String = unescaped;
            escaped = URI.fastEscapeChars(unescaped, URI.URIqueryPartExcludedBitmap);
            return (escaped);
        }
        public static function queryPartUnescape(escaped:String):String{
            var unescaped:String = escaped;
            unescaped = unescapeChars(unescaped);
            return (unescaped);
        }
        protected static function compareStr(str1:String, str2:String, sensitive:Boolean=true):Boolean{
            if (sensitive == false){
                str1 = str1.toLowerCase();
                str2 = str2.toLowerCase();
            };
            return ((str1 == str2));
        }
        protected static function resolve(uri:URI):URI{
            var copy:URI = new (URI);
            copy.copyURI(uri);
            if (_resolver != null){
                return (_resolver.resolve(copy));
            };
            return (copy);
        }
        public static function set resolver(resolver:IURIResolver):void{
            _resolver = resolver;
        }
        public static function get resolver():IURIResolver{
            return (_resolver);
        }

    }
}//package com.adobe.net 
