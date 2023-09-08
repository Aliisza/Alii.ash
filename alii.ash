import <zlib.ash>
boolean[string] available_choices;
void main(string settings) {
	// task keywords
	foreach task in $strings[
		coffee,
		ascend,
		gyou,
		cs,
		lunch,
		smoke
	] available_choices[task] = false;
	// abbreviations
	string[string] abbreviations = {
		# "all": "coffee ascend gyou cs lunch smoke",
		"post" :"lunch smoke",
		"gloop":"coffee ascend gyou lunch smoke",
		"cloop":"coffee ascend cs smoke",
		"crash":"cs smoke"
	};
	// parse settings
	foreach i,key in settings.to_lower_case().split_string(" ") {
		if (abbreviations contains key) {
			print(`Running choice {key}!`, "teal");
			foreach i,task in abbreviations[key].split_string(" ")
				available_choices[task] = true;
		}
		else if (available_choices contains key) {
			print(`Running choice {key}!`, "teal");
			available_choices[key] = true;
		}
	}
	// selected tasks run in this order:
	foreach task in $strings[coffee, ascend, gyou, cs, lunch, smoke]
		if (available_choices[task])
			call void task();
}

void HandleC2T() {
	//If you use c2t to handle your ascensions for cs. MAKE SURE TO CHECK THE 2ND STRING to make sure it picks the correct class and astral items.
	if (available_choices["gyou"]) {
		set_property("c2t_ascend", "2,27,2,44,8,5046,5039,2,0");
	}
	if (available_choices["cs"]) {
		set_property("c2t_ascend", "2,3,2,25,2,5046,5037,2,0");
	}
}

void yachtzee() {
	if(my_adventures() == 0 && my_inebriety() > inebriety_limit()) {
		print("We're overdrunk, and have used all our turns. This leg is finished. Moving on to ascending.", "red");
	}else if (my_inebriety() > inebriety_limit()) {
		print("We're overdrunk. Running Garbo overdrunk turns.", "blue");
		cli_execute("garbo");
		}else if(get_property("ascensionsToday").to_int() == 1) {
				print("We have already ascended today. We will not Yachtzeechain this leg.", "blue");
				cli_execute("garbo");
			}else {
				print("We have not ascended today. Breakfast leg always does Yachtzee!", "blue");
				if(!to_boolean(get_property("_sleazeAirportToday"))){
					if (item_amount($item[one-day ticket to Spring Break Beach]) > 0 || buy(1, $item[one-day ticket to Spring Break Beach], 375000) > 0)  {
							use(1, $item[one-day ticket to Spring Break Beach]);
					}
				}
			cli_execute("garbo yachtzeechain ascend workshed=cmc");
			cli_execute("shrug ur-kel");
			cli_execute("drink stillsuit distillate");
			cli_execute("CONSUME NIGHTCAP");
			}		
}

void coffee() {
	print("Doing start-of-day activities!", "teal");
	if(!get_property("_coffeeBegin").to_boolean()){
		cli_execute("ptrack add coffeeBegin");
		set_property("_coffeeBegin", "true");
	}
	if(!to_boolean(get_property("breakfastCompleted"))){
		cli_execute("breakfast");
		cli_execute("/whitelist cgc");
		cli_execute("acquire carpe");
	}
	if (!get_property("_essentialTofuUsed").to_boolean()) {
		print("Tofu unused! Trying to buy some!", "teal");
		buy(1, $item[essential tofu], get_property("valueOfAdventure").to_int() * 4);
		if (item_amount($item[essential tofu]) > 0) {
			use(1, $item[Essential Tofu]);
		}
		else {
			print("Tofu is more expensive than would be vialble. Skipping Tofu.");
		}
	} // FYI: Garbo usually doesn't use one of these, so free 5 adventures. Yay!
	yachtzee();
	yachtzee();
}

void ascend() {
	if(my_inebriety() <= inebriety_limit()){
		abort("You have not nightcapped yet! Overdrink and burn turns, then run again!");
	}else if(my_inebriety() > inebriety_limit() && my_adventures() > 0){
		abort("You have nightcapped, but have turns remaining! Burn turns, then run again!");
	}
	print("Jumping through the Gash!", "teal");
	HandleC2T();
	wait(5);
	cli_execute("c2t_ascend"); //c2t call to ascend. Change settings via the relay page.
	visit_url("choice.php"); //think I still need to click thru the choice adv
	run_choice(1);
}

void gyou() {
	print("Running gyou!", "teal");
	if(!get_property("_gyouBegin").to_boolean()){
		cli_execute("ptrack add gyouBegin");
		set_property("_gyouBegin", "true");
	}
	cli_execute("loopgyou");
	if (my_adventures() >= 41) {
		cli_execute("PandAliisza 40");//call using 40 as arg. Should execute script but stop when advs remaining is == 40
	}
	print("Breaking the Prism in t-10 seconds", "teal");
	waitq(16);
	visit_url("place.php?whichplace=nstower&action=ns_11_prism");
	visit_url("main.php");
	run_choice(1); //Change number to pick class. 1=SC; 2=TT; 3=PM; 4=SA; 5=DB; 6=AT
	visit_url("main.php");
}

void cs() {
	print("Running CS!", "teal");
	if(!get_property("_csBegin").to_boolean()){
		cli_execute("ptrack add csBegin");
		set_property("_csBegin", "true");
	}
	cli_execute("lcswrapper");
	cli_execute("make deep dish of legend");
	use($item[Asdon Martin keyfob]);
	visit_url(`uneffect.php?using=Yep.&pwd&whicheffect={$effect[Citizen of a Zone].id}`);//try uneffecting madness bakery eagle buff so garbo gets meat
}

void lunch() {
	print("Having a bite and leveling up!", "teal");
	cli_execute("hagnk all");
	if(!get_property("_lunchBegin").to_boolean()){
		cli_execute("ptrack add lunchBegin");
		set_property("_lunchBegin", "true");
		cli_execute("/whitelist cgc");
		cli_execute("acquire carpe");  //This is here becasue sometimes buffy be slow.	
	}
	if(my_level() < 13){
		cli_execute("levelup");
	}
	if(!have_skill($skill[Liver of Steel])){
		cli_execute("PandAliisza 5");//call using random low number of adventures remaining, but more than 0 for testing
	}
	if(item_amount($item[steel margarita]) > 0) {
		drink($item[Steel margarita]);
	}
	use($item[Asdon Martin keyfob]);
	//janky handling of using shotglass to make use of the +5 turns from blender before swapping to Wombat.
	if (!to_boolean(get_property("_mimeArmyShotglassUsed"))) {
		print("We have not used shotglass yet.");
		if (item_amount($item[astral six-pack]) > 0) {
			use($item[astral six-pack]);
		}
		drink(1, $item[astral pilsner]);
	}
	else {
		print("We already used our shotglass...somehow. Big sad!");
	}
	//tuning to wombat
	if ((!get_property('moonTuned').to_boolean()) && (my_sign() != "Wombat") && (available_amount($item[Hewn moon-rune spoon]).to_boolean()) ) {
		foreach sl in $slots[acc1, acc2, acc3] {
			if (equipped_item(sl) == $item[Hewn moon-rune spoon]) {
				equip(sl, $item[none]);
			}
		}
		visit_url("inv_use.php?whichitem=10254&doit=96&whichsign=7");
	}
	//monkey paw wishes cause garbo does silly things in post gyou leg
	visit_url("main.php?action=cmonk&pwd");
	foreach str in $strings["Frosty", "Sinuses for Miles", "Braaaaaains", "Frosty", "Sinuses for Miles"] {
		run_choice(1, `wish=${str}`);
	}
	visit_url("main.php");
}

void smoke() {
	print("Running garbo and ending the day off!", "teal");
	if(!get_property("_smokeBegin").to_boolean()){
		cli_execute("ptrack add smokeBegin");
		set_property("_smokeBegin", "true");
	}
	print("Stashing most of our meat for safe keeping, and anti-heckup!", "green");
	put_closet(max(0, my_meat() - 10000000)); //Stash all but 10mil meat while saving up big numbers
	//max function returns whichever is higher. So in the case of less than 10mil, 0 is returned and nothing is closeted
	if(!to_boolean(get_property("breakfastCompleted"))){
		cli_execute("breakfast");
		cli_execute("/whitelist cgc");
	}
	if (!to_boolean(get_property("_floundryItemCreated"))) {
		cli_execute("acquire carpe");
	}
	if (!get_property("_essentialTofuUsed").to_boolean()) {
		print("Tofu unused! Trying to buy some!", "teal");
		cli_execute(`buy essential tofu @{(get_property("valueOfAdventure").to_int() * 4)}`);
		if (item_amount($item[essential tofu]) > 0) {
				use(1, $item[Essential Tofu]);
		}else{
			print("Tofu is more expensive than would be vialble. Skipping Tofu.");
		}
	} //FYI: Garbo usually doesn't use one of these, so free 5 adventures. Yay!
	yachtzee();
	cli_execute("shrug ur-kel");
	cli_execute("CONSUME NIGHTCAP");
	if(get_property("_augSkillsCast").to_int() == 4) {
		print("Casting Offhand Remarkable.", "blue");
		use_skill(1, $skill[7464]);
	}
	retrieve_item($item[Burning cape]);
	//Buy as many day passes as Disney bucks and beach bucks allow
	if (get_property("_dinseyGarbageDisposed").to_boolean()) {
		buy($coinmaster[The Dinsey Company Store], floor((item_amount($item[Funfunds&trade;]) / 20)), $item[One-day ticket to dinseylandfill]);
	}
	if (get_property("_sleazeAirportToday").to_boolean()) {
		buy($coinmaster[Buff Jimmy's Souvenir Shop], floor((item_amount($item[Beach Buck]) / 100)), $item[One-day ticket to Spring Break Beach]);
	}
	if (item_amount($item[clockwork maid]) > 0 || buy(1, $item[clockwork maid], get_property("valueOfAdventure").to_int() * 8) > 0)  {
    		use(1, $item[clockwork maid]);
	}// Refrains from using a clockwork maid if you it's lower then 8x VOA 
	cli_execute("rollover management.ash");
	//Maximize string that prioritizes adventures, and values sasq watch for the meat buff
	maximize(`{get_property("valueOfAdventure")} adventures, 15000 bonus ¶7776, +equip ratskin pajama pants, +equip spacegate scientists insignia`, false);
	cli_execute("ptrack add smokeEnd");
	cli_execute("mallbuy 9999 surprisingly capacious handbag @ 120");
	cli_execute("mallbuy 9999 fireclutch @ 650");
	cli_execute("pTrack recap");

	if (item_amount($item[navel ring of navel gazing]) > 0) {
		print("Returning ring to Noob.");
		kmail("Noobsauce", "Returning your ring.", 0, int[item] {$item[navel ring of navel gazing] : 1});
	}
	cli_execute("raffle 11");
	print("Done!", "teal");
	print("Don't forget to check out the free Aug Scepter skill and cast if it's useful.", "pink");
}