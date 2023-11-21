package com.reeltrack.echo;

import com.monumental.trampoline.component.CompCMEntity;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.GregorianCalendar;

public class EchoCircuit extends CompCMEntity {
	public static final String PARAM = "transaction_param";
	public static final String ORDNO_COLUMN = "OrdNo";
	public static final String POREVISION_COLUMN = "PORevision";
	public static final String ABSOLUTEITEM_COLUMN = "AbsoluteItem";
	public static final String REELSERIAL_COLUMN = "ReelSerial";
	public static final String SYNCED_DATE_COLUMN = "synced_date";
	public static final String REEL_ID_COLUMN = "reel_id";
	public static final String LENGTH_COLUMN = "length";
	public static final String NAME_COLUMN = "name";
	public static final String IS_PULLED_COLUMN = "is_pulled";

	@Override
	public String getTableName() {
		return "reeltrack_circuits";
	}

	@Override
	public String getTypeName() {
		return "reeltrack_circuits";
	}

	public String getSeqTableName() {
		return "reeltrack_circuits_seq";
	}
	
	@Override
	public String getTitle() {
		return "";
	}

	public int getLength() {
		return this.getData().getInteger(LENGTH_COLUMN, 0);
	}
	
	public void setLength(int id) {
		this.getData().setInteger(LENGTH_COLUMN, id);
	}

	public String getName() {
		return this.getData().getString(NAME_COLUMN, "");
	}
	
	public void setName(String note) {
		this.getData().setString(NAME_COLUMN, note);
	}

	public String getIsPulled() {
		return this.getData().getString(IS_PULLED_COLUMN, "");
	}
	
	public void setIsPulled(String note) {
		this.getData().setString(IS_PULLED_COLUMN, note);
	}

	public Date getSyncedDate() {
        return (Date) this.getData().getValue(SYNCED_DATE_COLUMN, null);
    }

    public void setSyncedDate(Date toSet) {
        this.getData().setTimestamp(SYNCED_DATE_COLUMN, toSet);
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

   	public int getReelId() {
		return this.getData().getInteger(REEL_ID_COLUMN, new Integer(0));
    }

    public void setReelId(int id) {
		this.getData().setInteger(REEL_ID_COLUMN, new Integer(id));
    }
}
