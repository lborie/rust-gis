use postgres::{Client, NoTls};
use postgis::{ewkb};

fn main() {
    let mut config = Client::configure();
    config.host("localhost");
    config.user("karnott");
    config.password("12345678");
    config.dbname("karnott");
    let mut client = config.connect(NoTls).unwrap();

    for row in &client.query("SELECT geom FROM \"regions-20180101\"", &[]).unwrap() {
        let geom: ewkb::MultiPolygon = row.get("geom");
        println!("{}", geom.srid.unwrap())
    }
    println!("Hello, rust-gis!");
}
