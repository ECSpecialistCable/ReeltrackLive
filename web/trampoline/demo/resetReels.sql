update reels set status='ordered';
update reels set wharehouse_location='N/A';
delete from reel_logs;
delete from reel_issues;
delete from reel_circuits;
delete from reel_notes;	
update reels set projected_shipping_date = null;
update reels set shipping_date = null;
update reels set received_on = null;
update reels set receiving_issue = '';
update reels set receiving_note = '';
update reels set receiving_disposition = '';
update reels set bottom_foot = 0;
update reels set top_foot = 0;
update reels set cable_used_quantity = 0;
update reels set shipped_quantity = 0;
update reels set received_quantity = 0;
update reels set on_reel_quantity = 0;
update reels set received_weight = 0;
update reels set current_weight = 0;