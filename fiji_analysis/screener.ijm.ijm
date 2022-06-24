close("Results");
pd_path = "C:/Users/Student/Documents/bep_toolset/bep_tools/fiji_analysis/data/0206_assay/input_data/";
img_path = "Y:/PATH-Pathologie/220602 ar jfx646 pcna mscarlet PACE MvR/export_images/220602 ar jfx646 pcna mscarlet PACE MvR__2022-06-02T16_55_19-Measurement 1/Images/";

run("Results... "," open=[" +pd_path + "objects_coloc_wt_plus_GJK.txt]");
//open("C:/Users/Student/Documents/bep_toolset/bep_tools/fiji_analysis/data/Objects_Population - coloc_wt_plusGJK.csv");
//Table.rename("Objects_Population - coloc_wt_plusGJK.csv", "Results");



for (i = 0; i<nResults ; i++){
	r = getResult("Row", i);
	c = getResult("Column", i);
	p = getResult("Plane", i);
	t = getResult("Timepoint", i);
	f = getResult("Field", i);
	
	
	// Bounding Box
	bb = getResultString("Bounding Box", i);
	print("BB " + substring(bb, bb.indexOf("[") + 1, bb.indexOf(",")));
	
	arr_bb = newArray(4);
	idx1 = bb.indexOf("[") + 1;
	
	for (i = 0; i<4; i++){
		idx2 = indexOf(bb,",", idx1+1);
		//print(idx1, idx2);
		if (idx2 < 0){
			arr_bb[i] = substring(bb, idx1, indexOf(bb, "]"));
		}
		else{
			arr_bb[i] = substring(bb, idx1, idx2);
		}
		idx1 = idx2 + 1;
		//print(arr_bb[i]);
	}
	
	// Opening Images
	img_channel_1 = 
	"r" + String.pad(r, 2) +
	"c" + String.pad(c, 2) +
	"f" + String.pad(f, 2) +
	"p" + String.pad(p, 2) +
	"-ch1sk" + String.pad(t, 2) +
	"fk1fl1.tiff";

	img_channel_2 = 
	"r" + String.pad(r, 2) +
	"c" + String.pad(c, 2) +
	"f" + String.pad(f, 2) +
	"p" + String.pad(p, 2) +
	"-ch2sk" + String.pad(t, 2) +
	"fk1fl1.tiff";
	
	open(img_path + img_channel_1);
	open(img_path + img_channel_2);
	
	run("Merge Channels...", "c1=" + img_channel_1 + " c2=" + img_channel_2 + " create");
	
	Stack.setDisplayMode("color");
	
	// Boundbox on images
	makeRectangle(arr_bb[0], arr_bb[1], arr_bb[2] - arr_bb[0], arr_bb[3] - arr_bb[1]);
	
//	Dialog.create("This is a dialog?");	
//	Dialog.addCheckbox("is this a spot?" , false);
//	Dialog.show();
//	test = Dialog.getCheckbox();
//	
//	print(test);
	
	exit();
}

