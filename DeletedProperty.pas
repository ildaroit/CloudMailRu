unit DeletedProperty;

interface

uses
	MRC_Helper, CloudMailRu, Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics, Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls;

type
	TDeletedPropertyForm = class(TForm)
		DelNameLB: TLabel;
		DelFromLB: TLabel;
		DelAtLB: TLabel;
		DelByLB: TLabel;
		RestoreBTN: TButton;
		CancelBTN: TButton;
		NameLB: TLabel;
		FromLB: TLabel;
		AtLB: TLabel;
		ByLB: TLabel;
		SizeLB: TLabel;
		RestoreAllBTN: TButton;
		EmptyBTN: TButton;
		DelSizeLB: TLabel;
	private
		{Private declarations}
	public
		{Public declarations}
		class function ShowProperties(parentWindow: HWND; Items: TCloudMailRuDirListing; TrashDir: boolean = false; AccountName: WideString = ''): integer;
	end;

implementation

{$R *.dfm}
{TDeletedPropertyForm}

class function TDeletedPropertyForm.ShowProperties(parentWindow: HWND; Items: TCloudMailRuDirListing; TrashDir: boolean = false; AccountName: WideString = ''): integer;
var
	DeletedPropertyForm: TDeletedPropertyForm;
	FormCaption, NameCaption, FromCaption, AtCaption, ByCaption, SizeCaption: WideString;
	function summary_size(Items: TCloudMailRuDirListing): integer;
	var
		Item: TCloudMailRuDirListingItem;
	begin
		for Item in Items do Result:=Result + Item.size;
	end;

begin
	try
		DeletedPropertyForm:=TDeletedPropertyForm.Create(nil);
		DeletedPropertyForm.parentWindow := parentWindow;

		if Length(Items) = 0 then
		begin
			NameCaption := 'Empty';
			FormCaption := AccountName + ' trash';
			DeletedPropertyForm.RestoreBTN.Enabled:=false;
			DeletedPropertyForm.RestoreAllBTN.Enabled:=false;
			DeletedPropertyForm.EmptyBTN.Enabled:=false;
		end else if Length(Items) = 1 then
		begin
			NameCaption := Items[0].name;
			FromCaption := Items[0].deleted_from;
			AtCaption := Items[0].deleted_at.ToString; //todo from unixtimestamp ?
			ByCaption := Items[0].deleted_by.ToString; //todo check api user to name
			SizeCaption := FormatSize(Items[0].size);
			FormCaption := 'Deleted item: ' + NameCaption;
			DeletedPropertyForm.RestoreAllBTN.Enabled:=false;
		end else begin
			NameCaption := '<Multiple items>';
			FromCaption := '-';
			AtCaption :='-';
			ByCaption := '-';
			SizeCaption := FormatSize(summary_size(Items));
			FormCaption := 'Multiple deleted items';
		end;

		if TrashDir then //�������� ��� ����� �������, ��� ����� ��������/������������ ���/������
		begin
			FormCaption := AccountName + '.trash';
			NameCaption := FormCaption;
			FromCaption := '-';
			AtCaption :='-';
			ByCaption := '-';
			DeletedPropertyForm.RestoreBTN.Enabled:=false;
			DeletedPropertyForm.RestoreAllBTN.Enabled:=true;
		end else begin //�������� ��� ����� ������, ��� ����� ������������/������

		end;

		DeletedPropertyForm.Caption := FormCaption;
		DeletedPropertyForm.DelNameLB.Caption := NameCaption;
		DeletedPropertyForm.DelFromLB.Caption := FromCaption;
		DeletedPropertyForm.DelAtLB.Caption := AtCaption;
		DeletedPropertyForm.DelByLB.Caption := ByCaption;
		DeletedPropertyForm.DelSizeLB.Caption := SizeCaption;
		Result:=DeletedPropertyForm.ShowModal;
	finally
		FreeAndNil(DeletedPropertyForm);
	end;
end;

end.