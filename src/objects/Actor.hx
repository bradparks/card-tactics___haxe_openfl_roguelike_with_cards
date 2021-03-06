package objects;

import objects.GameObject.HealthData;
import ui.MoveCard.MoveData;

class Actor extends GameObject {

	var data:ActorData;

	public function new(data:ActorData, x:Int, y:Int) {
		trace(data);
		super(x, y, data.health, data.id);
	}

}

typedef ActorData = {
	id:String,
	gear:Array<String>,
	movement:MoveData,
	health:HealthData,
}

enum ActorMovement {
	
}