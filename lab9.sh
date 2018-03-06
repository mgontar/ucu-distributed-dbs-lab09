#!/bin/bash

reset

printf "Clear previouse setup\n"

sudo docker stop $(sudo docker ps -a -q)
sudo docker rm $(sudo docker ps -a -q)
sudo docker network rm $(sudo docker network ls -q -f type=custom)


# Task 0: init
printf "Task 0: init database\n"

sudo docker pull mongo

sudo docker run -d -v /home/mgontar/dev/lab9/data:/root/data \
-p 30001:27017 --name mdb mongo mongod --port 27017

sleep 30s

sudo docker exec -it mdb mongo --eval "load('root/data/lab9_init_db.js');"

sudo docker exec -it mdb mongo --quiet --eval 'db = (new Mongo("localhost:27017")).getDB("market");db.products.find(); db.orders.find();'

# Task 1: Calculate number of products by producer
printf "Task 1: Calculate number of products by producer\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {emit(this.producer, 1);};
var reduceFunc = function(key, values) { return Array.sum(values); };
db = (new Mongo("localhost:27017")).getDB("market");
db.products.mapReduce(mapFunc, reduceFunc, { out: "mrresult" });
db.mrresult.find();'

# Task 2: Calculate sum of price of products by producer
printf "Task 2: Calculate sum of price of products by producer\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {emit(this.producer, this.price);};
var reduceFunc = function(key, values) { return Array.sum(values); };
db = (new Mongo("localhost:27017")).getDB("market");
db.products.mapReduce(mapFunc, reduceFunc, { out: "mrresult" });
db.mrresult.find();'

# Task 3: Calculate sum of cost of orders by customer
printf "Task 3: Calculate sum of cost of orders by customer\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {emit(this.customer.name +" "+ this.customer.surname, this.total_sum);};
var reduceFunc = function(key, values) { return Array.sum(values); };
db = (new Mongo("localhost:27017")).getDB("market");
db.orders.mapReduce(mapFunc, reduceFunc, { out: "mrresult" });
db.mrresult.find();'

# Task 4: Calculate sum of cost of orders by customer in date range
printf "Task 4: Calculate sum of cost of orders by customer in date range\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {emit(this.customer.name +" "+ this.customer.surname, this.total_sum);};
var reduceFunc = function(key, values) { return Array.sum(values); };
db = (new Mongo("localhost:27017")).getDB("market");
db.orders.mapReduce(mapFunc, reduceFunc, { out: "mrresult", 
query: { date: { $gt: new Date("2017-12-09"), $lt: new Date("2017-12-16")}}});
db.mrresult.find();'

# Task 5: Calculate avg cost of orders
printf "Task 5: Calculate avg cost of orders\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {emit("average cost", this.total_sum);};
var reduceFunc = function(key, values) { return {sum:Array.sum(values), count:values.length}; };
db = (new Mongo("localhost:27017")).getDB("market");
var finalizeFunc = function (key, redVal) {return redVal.sum/redVal.count;};
db.orders.mapReduce(mapFunc, reduceFunc, { out: "mrresult", finalize: finalizeFunc});
db.mrresult.find();'

# Task 6: Calculate avg cost of orders by customers
printf "Task 6: Calculate avg cost of orders by customers\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {emit(this.customer.name +" "+ this.customer.surname, this.total_sum);};
var reduceFunc = function(key, values) { return Array.sum(values)/values.length; };
db = (new Mongo("localhost:27017")).getDB("market");
db.orders.mapReduce(mapFunc, reduceFunc, { out: "mrresult"});
db.mrresult.find();'

# Task 7: Calculate number of orders by product
printf "Task 7: Calculate number of orders by product\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {
for( i = 0; i < this.order_items_id.length; i++ ) {
emit(this.order_items_id[i], 1);}};
var reduceFunc = function(key, values) { return  Array.sum(values); };
db = (new Mongo("localhost:27017")).getDB("market");
db.orders.mapReduce(mapFunc, reduceFunc, { out: "mrresult"});
db.mrresult.find();'

# Task 8: List customers of orders by product
printf "Task 8: List customers of orders by product\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {
for( i = 0; i < this.order_items_id.length; i++ ) {
emit(this.order_items_id[i], this.customer.name +" "+ this.customer.surname);}};
var reduceFunc = function(key, values) { return {customers: values}; };
db = (new Mongo("localhost:27017")).getDB("market");
db.orders.mapReduce(mapFunc, reduceFunc, { out: "mrresult"});
db.mrresult.find();'

# Task 9: List customers of orders by product count
printf "Task 9: List customers of orders by product count\n"
sudo docker exec -it mdb mongo \
--eval 'var mapFunc = function() {
for( i = 0; i < this.order_items_id.length; i++ ) {
emit({item:this.order_items_id[i], customer:this.customer.name +" "+ this.customer.surname}, 1);}};
var reduceFunc = function(key, values)  { return  Array.sum(values); }; 
db = (new Mongo("localhost:27017")).getDB("market");
db.orders.mapReduce(mapFunc, reduceFunc, { out: "mrresult"});
db.mrresult.find();
var mapFunc2 = function() {emit(this._id, this.values);};
var reduceFunc2 = function(key, values) { return  Array.sum(values); };
db.mrresult.mapReduce(mapFunc2, reduceFunc2, { out: "mrresult2", query:{"value": {$gt: 0}}});
db.mrresult2.find();'
