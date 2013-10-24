package com.reeltrack.echo;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class EchoTransaction extends CompCMEntity {
	public static final String PARAM = "transaction_param";
	public static final String ORDNO_COLUMN = "OrdNo";
	public static final String POREVISION_COLUMN = "PORevision";
	public static final String ABSOLUTEITEM_COLUMN = "AbsoluteItem";
	public static final String REELSERIAL_COLUMN = "ReelSerial";

	@Override
	public String getTableName() {
		return "reeltrack_transactions";
	}

	@Override
	public String getTypeName() {
		return "reeltrack_transactions";
	}

	public String getSeqTableName() {
		return "reeltrack_transactions_seq";
	}
	
	@Override
	public String getTitle() {
		return "";
	}
	
	public String getOrdNo() {
		return this.getData().getString(ORDNO_COLUMN, "");
	}
	
	public void setOrdNo(String name) {
		this.getData().setString(ORDNO_COLUMN, name);
	}

	public int getPORevision() {
		return this.getData().getInteger(POREVISION_COLUMN, new Integer(0));
    }

    public void setPORevision(int id) {
		this.getData().setInteger(POREVISION_COLUMN, new Integer(id));
    }

	public int getAbsoluteItem() {
		return this.getData().getInteger(ABSOLUTEITEM_COLUMN, new Integer(0));
    }

    public void setAbsoluteItem(int id) {
		this.getData().setInteger(ABSOLUTEITEM_COLUMN, new Integer(id));
    }

	public int getReelSerial() {
		return this.getData().getInteger(REELSERIAL_COLUMN, new Integer(0));
    }

    public void setReelSerial(int id) {
		this.getData().setInteger(REELSERIAL_COLUMN, new Integer(id));
    }
}
