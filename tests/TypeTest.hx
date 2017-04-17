package;

import Db;
import tink.sql.Format;
import tink.sql.Info;
import tink.sql.drivers.MySql;
import tink.unit.Assert.assert;

using tink.CoreApi;

@:asserts
@:allow(tink.unit)
class TypeTest {
	
	var db:Db;
	var driver:MySql;
	
	public function new() {
		driver = new MySql({user: 'root', password: ''});
		db = new Db('test', driver);
	}
	
	@:before
	public function createTable() {
		return db.Types.create();
	}
	
	@:after
	public function dropTable() {
		return db.Types.drop();
	}
	
	public function insert() {
		var mydate = new Date(2000, 0, 1, 0, 0, 0);
		var future = db.Types.insertOne({
			int: 123,
			text: 'mytext',
			blob: haxe.io.Bytes.ofString('myblob'),
			date: mydate,
		}) >> 
			function(id:Int) return db.Types.first() >>
			function(row:Types) {
				asserts.assert(row.int == 123);
				asserts.assert(row.text == 'mytext');
				asserts.assert(row.date.getTime() == mydate.getTime());
				asserts.assert(row.blob.toHex() == '6d79626c6f62');
			}
			
		future.handle(function(o) switch o {
			case Success(_): asserts.done();
			case Failure(e): asserts.fail(e);
		});
		
		return asserts;
	}
}