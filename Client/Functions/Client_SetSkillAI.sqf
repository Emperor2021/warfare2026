
private ["_skill"];

while {!CTI_GameOver} do {
	_skill = call CTI_CL_FNC_GetSkillAI;

	{_x setSkill _skill} forEach units group player;

	sleep 10;
};
