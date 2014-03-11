package com.reeltrack.reels;

import com.monumental.trampoline.component.CompCMEntity;

public class CableTechData extends CompCMEntity {
	public static final String PARAM = "cable_tech_param";
	public static final String CONDUCTOR_AREA_COLUMN = "Conductor_Area";
	public static final String CONDUCTOR_GROUND_SIZE_COLUMN = "Conductor_GroundSize";
	public static final String INSULATION_THICKNESS_COLUMN = "Insulation_Thickness";
	public static final String INSULATION_COMPOUND_COLUMN = "Insulation_Compound";
	public static final String INSULATION_COLOR_COLUMN = "Insulation_Colorcode";
	public static final String SHIELD_TYPE_COLUMN = "ShieldType";
	public static final String JACKET_THICKNESS_COLUMN = "Jacket_Thickness";
	public static final String JACKET_COMPOUND_COLUMN = "Jacket_Compound";
	public static final String OD_COLUMN = "Cable_OD";
	public static final String WEIGHT_COLUMN = "Cable_Weight";
	public static final String RADIUS_COLUMN = "Cable_Radius";
	public static final String XSECTION_COLUMN = "Cable_XSection";
	public static final String PULL_TENSION_COLUMN = "Cable_PullTension";
	public static final String ECS_PN_COLUMN = "ECSPartNo";
	public static final String DATA_SHEET_FILE_COLUMN = "data_sheet_file";
	public static final String JOB_CODE_COLUMN = "job_code";
	public static final String EST_AL_WEIGHT_COLUMN = "est_al_weight";
	public static final String EST_CU_WEIGHT_COLUMN = "est_cu_weight";
	public static final String CON_AL_WEIGHT_COLUMN = "con_al_weight";
	public static final String CON_CU_WEIGHT_COLUMN = "con_cu_weight";
	public static final String USAGE_TRACKING_COLUMN = "usage_tracking";

	public static final String USAGE_FOOT_MARKERS = "foot markers";
	public static final String USAGE_WEIGHT = "weight";
	public static final String USAGE_QUANTITY_PULLED = "quantity pulled";

	public int getConAlWeight() {
		return this.getData().getInteger(CON_AL_WEIGHT_COLUMN, 0);
	}
	
	public void setConAlWeight(int id) {
		this.getData().setInteger(CON_AL_WEIGHT_COLUMN, id);
	}

	public int getConCuWeight() {
		return this.getData().getInteger(CON_CU_WEIGHT_COLUMN, 0);
	}
	
	public void setConCuWeight(int id) {
		this.getData().setInteger(CON_CU_WEIGHT_COLUMN, id);
	}

	public int getEstAlWeight() {
		return this.getData().getInteger(EST_AL_WEIGHT_COLUMN, 0);
	}
	
	public void setEstAlWeight(int id) {
		this.getData().setInteger(EST_AL_WEIGHT_COLUMN, id);
	}

	public int getEstCuWeight() {
		return this.getData().getInteger(EST_CU_WEIGHT_COLUMN, 0);
	}
	
	public void setEstCuWeight(int id) {
		this.getData().setInteger(EST_CU_WEIGHT_COLUMN, id);
	}

	public String getJobCode() {
		return this.getData().getString(JOB_CODE_COLUMN, "");
	}
	
	public void setJobCode(String name) {
		this.getData().setString(JOB_CODE_COLUMN, name);
	}

	public String getDataSheetFile() {
		return this.getData().getString(DATA_SHEET_FILE_COLUMN, "");
	}
	
	public void setDataSheetFile(String name) {
		this.getData().setString(DATA_SHEET_FILE_COLUMN, name);
	}
	
	public String getEcsPN() {
		return this.getData().getString(ECS_PN_COLUMN, "");
	}
	
	public void setEcsPN(String name) {
		this.getData().setString(ECS_PN_COLUMN, name);
	}
	
	public int getPullTension() {
		return this.getData().getInteger(PULL_TENSION_COLUMN, 0);
	}
	
	public void setPullTension(int id) {
		this.getData().setInteger(PULL_TENSION_COLUMN, id);
	}

	public double getXSection() {
		return this.getData().getDouble(XSECTION_COLUMN, 0.0);
	}
	
	public void setXSection(double id) {
		this.getData().setDouble(XSECTION_COLUMN, id);
	}

	public double getRadius() {
		return this.getData().getDouble(RADIUS_COLUMN, 0.0);
	}
	
	public void setRadius(double id) {
		this.getData().setDouble(RADIUS_COLUMN, id);
	}

	public int getWeight() {
		return this.getData().getInteger(WEIGHT_COLUMN, 0);
	}
	
	public void setWeight(int id) {
		this.getData().setInteger(WEIGHT_COLUMN, id);
	}

	public double getOD() {
		return this.getData().getDouble(OD_COLUMN, 0.0);
	}
	
	public void setOD(double id) {
		this.getData().setDouble(OD_COLUMN, id);
	}

	public String getJacketCompound() {
		return this.getData().getString(JACKET_COMPOUND_COLUMN, "");
	}
	
	public void setJacketCompound(String note) {
		this.getData().setString(JACKET_COMPOUND_COLUMN, note);
	}

	public int getJacketThickness() {
		return this.getData().getInteger(JACKET_THICKNESS_COLUMN, 0);
	}
	
	public void setJacketThickness(int id) {
		this.getData().setInteger(JACKET_THICKNESS_COLUMN, id);
	}

	public String getShieldType() {
		return this.getData().getString(SHIELD_TYPE_COLUMN, "");
	}
	
	public void setShieldType(String note) {
		this.getData().setString(SHIELD_TYPE_COLUMN, note);
	}

	public String getInsulationColor() {
		return this.getData().getString(INSULATION_COLOR_COLUMN, "");
	}
	
	public void setInsulationColor(String note) {
		this.getData().setString(INSULATION_COLOR_COLUMN, note);
	}

	public String getInsulationCompound() {
		return this.getData().getString(INSULATION_COMPOUND_COLUMN, "");
	}
	
	public void setInsulationCompound(String note) {
		this.getData().setString(INSULATION_COMPOUND_COLUMN, note);
	}

	public int getInsulationThickness() {
		return this.getData().getInteger(INSULATION_THICKNESS_COLUMN, 0);
	}
	
	public void setInsulationThickness(int id) {
		this.getData().setInteger(INSULATION_THICKNESS_COLUMN, id);
	}

	public String getConductorGroundSize() {
		return this.getData().getString(CONDUCTOR_GROUND_SIZE_COLUMN, "");
	}
	
	public void setConductorGroundSize(String note) {
		this.getData().setString(CONDUCTOR_GROUND_SIZE_COLUMN, note);
	}

	public int getConductorArea() {
		return this.getData().getInteger(CONDUCTOR_AREA_COLUMN, 0);
	}
	
	public void setConductorArea(int id) {
		this.getData().setInteger(CONDUCTOR_AREA_COLUMN, id);
	}

	public String getUsageTracking() {
		return this.getData().getString(USAGE_TRACKING_COLUMN, "");
	}

	public void setUsageTracking(String name) {
		this.getData().setString(USAGE_TRACKING_COLUMN, name);
	}

	@Override
	public String getTableName() {
		return "cable_tech_data";
	}

	@Override
	public String getTypeName() {
		return "cable tech data";
	}

	public String getSeqTableName() {
		return "cable_tech_data_seq";
	}
	
	@Override
	public String getTitle() {
		return "";
	}
}
