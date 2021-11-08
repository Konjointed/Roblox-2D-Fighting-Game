
local GlobalWidth = 3
local GlobalHeight = 1.6

local Moveset = {
	[1] = {
		MovePriority = 1;
		MoveType = "Ground";
		Name = "Light Punch";
		Sequence = {"LP"};
		Animation = "Punch1";
		Damage = 10;
		Stun = 50;
		Guage = 50;
		Effect = "TestEffect2", 
		--HitEffect = "" --Effects for when the move hits
		HitboxData = {
			Orientation = {0,90,0};
			ProxBlockAreaSize = Vector3.new(GlobalWidth,GlobalHeight,1.8);
			ProxBlockAreaPos = {5,0};
			HitboxSize = Vector3.new(GlobalWidth, GlobalHeight, 6);
			HitboxPos = {2.5,0};			
		},
	},
	[2] = {
		MovePriority = 1;
		MoveType = "Ground";
		Name = "Medium Punch";
		Sequence = {"MP"};
		Animation = "Punch2";
		Damage = 10;
		Stun = 50;
		Guage = 50;
		HitboxData = {
			Orientation = {0,90,0};
			ProxBlockAreaSize = Vector3.new(GlobalWidth,GlobalHeight,1.8);
			ProxBlockAreaPos = {5,0};
			HitboxSize = Vector3.new(GlobalWidth, GlobalHeight, 6);
			HitboxPos = {2.5,0};			
		},
	},
	[3] = {
		MovePriority = 1;
		MoveType = "Ground";
		Name = "Hard Punch";
		Sequence = {"HP"};
		Animation = "Punch3";
		Damage = 10;
		Stun = 50;
		Guage = 50;
		HitboxData = {
			Orientation = {0,90,0};
			ProxBlockAreaSize = Vector3.new(GlobalWidth,GlobalHeight,1.8);
			ProxBlockAreaPos = {5,0};
			HitboxSize = Vector3.new(GlobalWidth, GlobalHeight, 6);
			HitboxPos = {2.5,0};			
		},
	},
	[4] = {
		MovePriority = 1;
		MoveType = "Crouch";
		Name = "Crouching Light Punch";
		Sequence = {"LP"};
		Animation = "CrouchPunch1";
		Damage = 10;
		Stun = 15;
		Guage = 10;
		HitboxData = {
			Orientation = {0,90,0};
			ProxBlockAreaSize = Vector3.new(GlobalWidth,GlobalHeight,1.8);
			ProxBlockAreaPos = {5,0};
			HitboxSize = Vector3.new(GlobalWidth, GlobalHeight, 6);
			HitboxPos = {2.5,0};			
		}
	},
}

return Moveset
