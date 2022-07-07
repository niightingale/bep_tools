// PRE TITLES
linear_save = "lin_lab.txt";
random_save = "ran_lab.txt";


close("Results");

function getView(row){
	arr = newArray(5);
	
	// Yield values for row selected
	r = getResult("Row", row);
	c = getResult("Column", row);
	p = getResult("Plane", row);
	t = getResult("Timepoint", row);
	f = getResult("Field", row);	
	
	arr[0] = r; 
	arr[1] = c;
	arr[2] = p;
	arr[3] = t;
	arr[4] = f;
	
	return arr;
}

function getBoundingBox(row){
	bb = getResultString("Bounding Box", row);
	
	arr_bb = newArray(4);
	idx1 = bb.indexOf("[") + 1;	// Set starting position
	
	for (i = 0; i<4; i++){
		idx2 = indexOf(bb, ",", idx1 + 1);	// Advance pointer 2
		// Check overflow
		if (idx2 < 0){
			arr_bb[i] = parseInt(substring(bb, idx1, indexOf(bb, "]")));
		}
		else{
			arr_bb[i] = parseInt(substring(bb, idx1, idx2));	// Obtain substring
		}
		idx1 = idx2 + 1;	// Advance pointer 1
	}
	return arr_bb;
}

function fetchImageNames(view_id, channel){
	// For fetching the image name from the view_id array
	img_title = "";
	
	img_title = 
	"r" + String.pad(view_id[0], 2) + 
	"c" + String.pad(view_id[1], 2) +
	"f" + String.pad(view_id[4], 2) + 
	"p" + String.pad(view_id[2], 2) +
	"-ch" + channel + "sk" + String.pad(view_id[3], 2) +
	"fk1fl1.tiff"; 
		
	return img_title;
}

function fetchShotG(view_id, channel, stack_depth){
	img_title = "";
	
	img_title = 
	"r" + String.pad(view_id[0], 2) + 
	"c" + String.pad(view_id[1], 2) +
	"f" + String.pad(view_id[4], 2) + 
	"p" + String.pad(round(stack_depth/2), 2) +
	"-ch" + channel + "sk" + String.pad(view_id[3] + 1, 1) +
	"fk1fl1.tiff"; 
		
	return img_title;

}

function fetchImageStacks(view_id, img_path, channel, stack_depth){
	// Fetch Titles
	titles_to_load = newArray(10);
	
	for (i = 0; i<stack_depth; i++){
		title = 
		"r" + String.pad(view_id[0], 2) +
		"c" + String.pad(view_id[1], 2) +
		"f" + String.pad(view_id[4], 2) +
		"p" + String.pad(i+1, 2) +
		"-ch" + channel + "sk" + String.pad(view_id[3], 1) +
		"fk1fl1.tiff"; 	
		titles_to_load[i] = title;	// Store title
	}
	
	// Open and Stack images
	for (j = 0; j<stack_depth; j++){
		open(img_path + titles_to_load[j]);
	}
	run("Images to Stack", "name=ch1 use");					// Obtain Stack
	run("Z Project...", "projection=[Max Intensity]");		// Max intensity projection
	close("ch1");											// Close stack
	saveAs("Tiff", "C:/Users/Student/Desktop/MAX_ch" + channel + ".tif");
	close("MAX_ch" + channel + ".tif");
//	str_filter ="(" + 
//				"r" + String.pad(view_id[0], 2) +
//				"c" + String.pad(view_id[1], 2) +
//				"f" + String.pad(view_id[4], 2) +
//				"p0"+ "[1" + "-"  + stack_depth  + "]" + 
//				"-ch" + channel + "sk" + String.pad(view_id[3], 1) +
//				")"; 	
//	print(str_filter);
//	File.openSequence(img_path, " filter=" + str_filter);
//	run("Z Project...", "projection=[Max Intensity]");
}

function boundingSetter(view_bb, flood){	
	bb_center_x = floor((view_bb[2] + view_bb[0]) / 2);
	bb_center_y = floor((view_bb[3] + view_bb[1]) / 2);
	
	//(bb_center_x, bb_center_y);
	
	//selectWindow("Composite");
	makeRectangle(bb_center_x - flood, bb_center_y - flood, 2 * flood, 2 * flood);
	
	// Calculate New Center
	// 1) Check Overflow
	novel_bb_center_x = 0;
	novel_bb_center_y = 0;
	
	if (bb_center_x - flood <= 0){
		novel_bb_center_x = bb_center_x;
	}
	else{
		novel_bb_center_x = flood;
	}
	
	if (bb_center_y - flood <= 0){
		novel_bb_center_y = bb_center_y;
	}
	else{
		novel_bb_center_y = flood;
	}
	arr_novel_bb = newArray(4);
	arr_novel_bb[0] = novel_bb_center_x - 2;
	arr_novel_bb[1] = novel_bb_center_y - 2;
	arr_novel_bb[2] = novel_bb_center_x + 2;
	arr_novel_bb[3] = novel_bb_center_y + 2;
	return arr_novel_bb;
	
}

function save(arr, to){
	f = File.open(to);
	
	for (i = 0; i < arr.length; i++){
		print(f, arr[i] + "\n");
	}
}

function loadTxt(path){
	text = File.openAsString(path);
	
	arr = newArray(1);
	
	in_file = true;
	counter = 0;
	pos = 0;
	
	// Extract Lines
	while(in_file){
		end = indexOf(text, "\n", pos + 1);
		// Stopper
		if(end >= text.lastIndexOf("\n")){
			in_file = false;
		}
		current_line = text.substring(pos, end);
		current_line.replace("\\", "/");
		//print(current_line);
		arr[counter] = current_line;
		counter++;
		pos = end + 1;
	}
	arr[arr.length] = counter;	// Put count at end of array
	return arr;
}

function randomArr(n, upper_limit){
	// Retrieve an array of 'n' random numbers
	arr = newArray(n);
	
	
	for (i = 0; i < n; i++){
		duplicate = true;
		
		while(duplicate){
			rn = round(random() * upper_limit);
			found = false;
			for (j = 0; j < n; j++){
				// Check if found
				if (arr[j] == rn){
					found = true;
				}
			}
			if (found == false){
				arr[i] = rn;
				duplicate = false;
			}
		}
		
		if (duplicate == false){
			// arr[i] = round(random() * n);
		}
	}
	Array.print(arr);
	return arr;
}

function _linearAssay(start_position, path_df, path_img, path_out, spotkeep, stack_depth){
	// LINEAR ASSAY: Go across all items in the dataframe one by one.
	for (i = 0; i < nResults; i++){
		// Start Where We Left
		if (i == 0 && start_position != 0){
			i = start_position;
		}
		
		// 1) Obtain Locus Data
		view_id = getView(i);			// Get view data for image lookup
		view_bb = getBoundingBox(i);	// Get bounding box data for bounding
		
		// 2) Fetch Image (Names)
		if (stack_depth == 0){
			img_channel_1 = fetchImageNames(view_id, 1);
			img_channel_2 = fetchImageNames(view_id, 2);

			open(img_path + img_channel_1);
			open(img_path + img_channel_2);
		}
		else{
//			img_channel_1 = fetchShotG(view_id, 1, stack_depth);
//			img_channel_2 = fetchShotG(view_id, 2, stack_depth);
//
//			open(img_path + img_channel_1);
//			open(img_path + img_channel_2);
			
			fetchImageStacks(view_id, img_path, 1, stack_depth);
			fetchImageStacks(view_id, img_path, 2, stack_depth);
			
			open("C:/Users/Student/Desktop/MAX_ch1.tif");
			img_channel_1 = "MAX_ch1.tif";
			open("C:/Users/Student/Desktop/MAX_ch2.tif");	
			img_channel_2 = "MAX_ch2.tif";
		}

		
		// 3) Process Images Into Composite
		run("Merge Channels...", "c1=" + img_channel_1 + " c2=" + img_channel_2 + " create");
		Stack.setDisplayMode("color");
		
		// 4) Boundingbox
		new_bb = boundingSetter(view_bb, 125);
		
		// 5) Process bounding box
		run("Duplicate...", "duplicate");
		selectWindow("Composite-1");
		rename("Merge");
		run("Enhance Contrast", "saturated=0.35");
		Stack.setChannel(2);
		run("Enhance Contrast", "saturated=0.35");
		
		//print("bb: " + new_bb[0], new_bb[1], new_bb[2], new_bb[3]);
		selectWindow("Merge");
		boundingSetter(new_bb, 25);	
		
		close("Composite");
		selectWindow("Merge");
		
		// 5) Inquire User
		Dialog.createNonBlocking("Spotter");
		Dialog.addMessage("At " + (i + 1) + " of " + nResults);
		Dialog.addMessage("Is there a spot?", false);
		Dialog.addCheckbox("Is there a spot?", false);
		
		
		Dialog.addMessage("Other Options");
		options = newArray("continue", "go back", "terminate");
		Dialog.addChoice("Options", options);
		
		
		Dialog.show();
		
		test = Dialog.getCheckbox();
		choice = Dialog.getChoice();

		// 1) go back once
		if (choice == "go back"){
			i = i - 2;
		}
		// 2) terminate assay (+saving)
		if (choice == "terminate" && i > 0){
			// Saving with is zero safeguard
			save(spotkeep, path_output + "/" + linear_save);
			exit();
		}
		// 3) Go on
		if (choice == "continue"){
			// Store in Spotkeep
			spotkeep[i] = test;	
			// Store as tiff
			saveAs("Tiff", path_output 
			+ "r" + view_id[0] + "c" + view_id[1] + "p" + view_id[2]
			+ "f" + view_id[4] + "t" + view_id[3] + "cl" + test);
		}	

		close("*");
	}
	// End save
	save(spotkeep, path_output + "/" + linear_save);
	return spotkeep;
}

function _randomAssay(len, path_df, path_img, path_out, spotkeep){
	// Obtain Random Numbers
	df = loadTxt(path_df);
	len_df = df[df.length - 1] - 1;
	print("LENGTH OF DF: ", len_df);
	arr_random = randomArr(len, len_df - 1);
	
	arr_random = newArray(138, 137);
	
	// Create annotation array
	arr_anno = newArray(len_df);
	Array.fill(arr_anno, 3);
	
	// Review All
	for (i = 0; i < arr_random.length; i++){
		// 1) Obtain Locus Data
		view_id = getView(arr_random[i]);
		view_bb = getBoundingBox(arr_random[i]);
		
		// 2) Fetch Image Names
		img_channel_1 = fetchImageNames(view_id, 1);
		img_channel_2 = fetchImageNames(view_id, 2);
		
		open(img_path + img_channel_1);
		open(img_path + img_channel_2);
		
		// 3) Process Images Into Composite
		run("Merge Channels...", "c1=" + img_channel_1 + " c2=" + img_channel_2 + " create");
		Stack.setDisplayMode("color");
		
		// 4) Boundingbox
		new_bb = boundingSetter(view_bb, 125);
		
		// 5) Process bounding box
		run("Duplicate...", "duplicate");
		selectWindow("Composite-1");
		rename("Merge");
		run("Enhance Contrast", "saturated=0.35");
		Stack.setChannel(2);
		run("Enhance Contrast", "saturated=0.35");
		
		//print("bb: " + new_bb[0], new_bb[1], new_bb[2], new_bb[3]);
		selectWindow("Merge");
		boundingSetter(new_bb, 25);	
		
		close("Composite");
		selectWindow("Merge");
		
		getStatistics(area, mean, min, max, std, histogram);
		
		Stack.setChannel(1);
			
		Dialog.createNonBlocking("Spotter Random");
		Dialog.addMessage("At " + (i + 1) + " of " + len); 
		Dialog.addMessage("Dataframe index: " + arr_random[i]);
		Dialog.addMessage("Is there a spot?", false);
		Dialog.addCheckbox("Is there a spot?", false);
		
		
		Dialog.addMessage("Other Options");
		options = newArray("continue", "go back", "terminate");
		Dialog.addChoice("Options", options);
		
		
		Dialog.show();
		
		test = Dialog.getCheckbox();
		choice = Dialog.getChoice();
		
		// go back once
		if (choice == "go back"){
			i = i - 2;
		}
		// terminate assay (+saving)
		if (choice == "terminate"){
			save(arr_anno, path_output + "/" + random_save);
			exit();
		}
		if (choice == "continue"){
			// Store in Spotkeep
			arr_anno[arr_random[i]] = test;	
			// Store as tiff
			saveAs("Tiff", path_output 
			+ "r" + view_id[0] + "c" + view_id[1] + "p" + view_id[2]
			+ "f" + view_id[4] + "t" + view_id[3] + "cl" + test);
		}
		
		close("*");
	}
	save(arr_anno, path_output + "/" + random_save);
}

spotkeep = newArray(nResults);

// INTRO
Dialog.create("Screener");
// > Quick Setup
Dialog.addMessage("Quick Setup", 14, "blue");
path_linker = Dialog.addDirectory("Linker", "")
Dialog.addMessage("A linker file automatically imports the paths that have to be specified below.");
// > Manual Setup
Dialog.addMessage("Manual Setup", 14, "blue");
path_df = Dialog.addDirectory("Dataframe", "C:/Users/Student/Documents/bep_toolset/bep_tools/fiji_analysis/data/0206_assay/input_data/objects_coloc_wt_plus_GJK.txt");
path_images = Dialog.addDirectory("Images", "Y:/PATH-Pathologie/220602 ar jfx646 pcna mscarlet PACE MvR/export_images/220602 ar jfx646 pcna mscarlet PACE MvR__2022-06-02T16_55_19-Measurement 1/Images/");
path_output = Dialog.addDirectory("Output", "C:/Users/Student/Documents/bep_toolset/bep_tools/fiji_analysis/data/0206_assay/output_data/0206_assay_coloc_wt_plus_rois/");
Dialog.addMessage("Directory of the folder that holds the images corresponding to the dataframe.");
// > Analysis Mode
Dialog.addMessage("Analysis Mode", 14, "blue");
options = newArray("linear", "random");
Dialog.addChoice("Analysis Mode", options);
Dialog.addToSameRow();
Dialog.addSlider("Samples", 25, 200, 50);
Dialog.addMessage("While storing the labeled list works for both analysis modes, loading only works for the linear mode.");
Dialog.addSlider("Stack Depth", 0, 15, 0);
Dialog.addMessage("This value is used in 'maximum projection' assays. It MUST be left on 0 when we are not working on such data.");

Dialog.show();

path_linker = Dialog.getString();
path_df = Dialog.getString();
img_path = Dialog.getString();
path_output = Dialog.getString();

choice_made = Dialog.getChoice();
random_length = Dialog.getNumber();
stack_depth = Dialog.getNumber();

start_position = 0;

// PRE | Use Linker
if (path_linker != ""){
	arr = loadTxt(path_linker);
	
	// Put in paths
	path_df = arr[0];
	img_path = arr[1];
	path_output = arr[2];
}

// PRE | Start Where We Left
if (File.exists(path_output + linear_save) && choice_made == "linear"){
	// Get ANNOTATION LIST (for annotations array & starting pos)
	arr = loadTxt(path_output + linear_save);
	
	start_position = arr[arr.length - 1];
	spotkeep = Array.slice(arr, 0, arr.length - 1);
}

run("Results... ","open=" + path_df);

if (choice_made == "linear"){
	spotkeep = _linearAssay(start_position, path_df, img_path, path_output, spotkeep, stack_depth);	
}
if (choice_made == "random"){
	_randomAssay(random_length, path_df, img_path, path_output, spotkeep);
}