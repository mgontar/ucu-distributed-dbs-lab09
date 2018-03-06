db = (new Mongo("localhost:27017")).getDB("market");
db.products.insert(
[{ 
    "category" : "Phone", 
    "model" : "iPhone 6", 
    "producer" : "Apple", 
    "price" : NumberInt(600)
},{ 
    "category" : "Phone", 
    "model" : "iPhone 5", 
    "producer" : "Apple", 
    "price" : NumberInt(400)
},{ 
    "category" : "Phone", 
    "model" : "iPhone 8", 
    "producer" : "Apple", 
    "price" : NumberInt(800)
},{ 
    "category" : "Phone", 
    "model" : "Galaxy J5", 
    "producer" : "Samsung", 
    "price" : NumberInt(200)
},{ 
    "category" : "Phone", 
    "model" : "Galaxy S8", 
    "producer" : "Samsung", 
    "price" : NumberInt(1200)
},{ 
    "category" : "Notebook", 
    "model" : "Yoga 710", 
    "producer" : "Lenovo", 
    "price" : NumberInt(1100)
},{ 
    "category" : "Notebook", 
    "model" : "ZenBook 3", 
    "producer" : "Asus", 
    "price" : NumberInt(1600)
},{ 
    "category" : "TV", 
    "model" : "UE40MU6172", 
    "producer" : "Samsung", 
    "price" : NumberInt(600)
},{ 
    "category" : "TV", 
    "model" : "32PHT4101", 
    "producer" : "Philips", 
    "price" : NumberInt(200)
}]);
db.orders.insert({
	"order_number" : 123123,
    "date" : ISODate("2017-12-10"),
    "total_sum" : 1700,
	"customer" : {
        "name" : "Ivan",
        "surname" : "Sydorenko",
        "phones" : ["09612312312"],
        "address" : "vul Zelena 300, Lviv, Ukraine"
    },
    "payment" : {
        "card_owner" : "Ivan Sydorenko",
        "cardId" : "342434744241868"
    },
	"order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a3bb1acd5b0c480829ee34c")
        },
        {
            "$ref" : "products",
            "$id" : ObjectId("5a3bb1acd5b0c480829ee351")
        }
    ]
});
db.orders.insert({
	"order_number" : 123144,
    "date" : ISODate("2017-12-15"),
    "total_sum" : 1300,
	"customer" : {
        "name" : "Dmytro",
        "surname" : "Konopenko",
        "phones" : ["09612312332"],
        "address" : "vul Zelena 32, Lviv, Ukraine"
    },
    "payment" : {
        "card_owner" : "Dmytro Konopenko",
        "cardId" : "375915470194941"
    },
	"order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a3bb1acd5b0c480829ee34f")
        },
        {
            "$ref" : "products",
            "$id" : ObjectId("5a3bb1acd5b0c480829ee351")
        }
    ]
});
db.orders.insert({
	"order_number" : 123156,
    "date" : ISODate("2017-12-21"),
    "total_sum" : 600,
	"customer" : {
        "name" : "Ivan",
        "surname" : "Sydorenko",
        "phones" : ["09612312312"],
        "address" : "vul Zelena 300, Lviv, Ukraine"
    },
    "payment" : {
        "card_owner" : "Ivan Sydorenko",
        "cardId" : "342434744241868"
    },
	"order_items_id" : [
        {
            "$ref" : "products",
            "$id" : ObjectId("5a3bb1acd5b0c480829ee353")
        }
    ]
});
