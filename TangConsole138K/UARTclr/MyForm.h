#pragma once

namespace UARTclr {

	using namespace System;
	using namespace System::ComponentModel;
	using namespace System::Collections;
	using namespace System::Windows::Forms;
	using namespace System::Data;
	using namespace System::Drawing;
	using namespace System::IO::Ports;
	using namespace System::IO;
	using namespace System::Configuration;

	/// <summary>
	/// MyForm の概要
	/// </summary>
	public ref class MyForm : public System::Windows::Forms::Form
	{

	private: System::Windows::Forms::Label^ label1;
	private: System::Windows::Forms::Label^ label2;
	private: System::Windows::Forms::Label^ label3;
	private: System::Windows::Forms::Label^ label4;
	private: System::Windows::Forms::TextBox^ tb_SaveFileName;

		   UInt16 pad_data;

	public:
		MyForm(void)
		{
			InitializeComponent();
			//
			//TODO: ここにコンストラクター コードを追加します
			//
		}

	protected:
		/// <summary>
		/// 使用中のリソースをすべてクリーンアップします。
		/// </summary>
		~MyForm()
		{
			if (components)
			{
				delete components;
			}
		}
	private: System::Windows::Forms::Button^ btn_Send;
	private: System::Windows::Forms::TextBox^ tb_RomFileName;

	private: System::Windows::Forms::ComboBox^ cb_COMs;
	private: System::IO::Ports::SerialPort^ serialPort;
	private: System::Windows::Forms::TextBox^ tb_Log;
	private: System::Windows::Forms::TextBox^ tb_Key;
	private: System::ComponentModel::IContainer^ components;
	private: System::Windows::Forms::Timer^ tm_Pad;

	protected:

	protected:

	private:
		/// <summary>
		/// 必要なデザイナー変数です。
		/// </summary>


#pragma region Windows Form Designer generated code
		/// <summary>
		/// デザイナー サポートに必要なメソッドです。このメソッドの内容を
		/// コード エディターで変更しないでください。
		/// </summary>
		void InitializeComponent(void)
		{
			this->components = (gcnew System::ComponentModel::Container());
			this->btn_Send = (gcnew System::Windows::Forms::Button());
			this->tb_RomFileName = (gcnew System::Windows::Forms::TextBox());
			this->cb_COMs = (gcnew System::Windows::Forms::ComboBox());
			this->serialPort = (gcnew System::IO::Ports::SerialPort(this->components));
			this->tb_Log = (gcnew System::Windows::Forms::TextBox());
			this->tb_Key = (gcnew System::Windows::Forms::TextBox());
			this->tm_Pad = (gcnew System::Windows::Forms::Timer(this->components));
			this->label1 = (gcnew System::Windows::Forms::Label());
			this->label2 = (gcnew System::Windows::Forms::Label());
			this->label3 = (gcnew System::Windows::Forms::Label());
			this->label4 = (gcnew System::Windows::Forms::Label());
			this->tb_SaveFileName = (gcnew System::Windows::Forms::TextBox());
			this->SuspendLayout();
			// 
			// btn_Send
			// 
			this->btn_Send->Font = (gcnew System::Drawing::Font(L"MS UI Gothic", 14.25F, System::Drawing::FontStyle::Regular, System::Drawing::GraphicsUnit::Point,
				static_cast<System::Byte>(128)));
			this->btn_Send->Location = System::Drawing::Point(101, 113);
			this->btn_Send->Name = L"btn_Send";
			this->btn_Send->Size = System::Drawing::Size(131, 51);
			this->btn_Send->TabIndex = 0;
			this->btn_Send->Text = L"Send !";
			this->btn_Send->UseVisualStyleBackColor = true;
			this->btn_Send->Click += gcnew System::EventHandler(this, &MyForm::btn_Send_Click);
			// 
			// tb_RomFileName
			// 
			this->tb_RomFileName->AllowDrop = true;
			this->tb_RomFileName->Location = System::Drawing::Point(101, 33);
			this->tb_RomFileName->Name = L"tb_RomFileName";
			this->tb_RomFileName->Size = System::Drawing::Size(322, 19);
			this->tb_RomFileName->TabIndex = 1;
			this->tb_RomFileName->DragDrop += gcnew System::Windows::Forms::DragEventHandler(this, &MyForm::tb_RomFileName_DragDrop);
			this->tb_RomFileName->DragEnter += gcnew System::Windows::Forms::DragEventHandler(this, &MyForm::tb_RomFileName_DragEnter);
			// 
			// cb_COMs
			// 
			this->cb_COMs->FormattingEnabled = true;
			this->cb_COMs->Location = System::Drawing::Point(12, 32);
			this->cb_COMs->Name = L"cb_COMs";
			this->cb_COMs->Size = System::Drawing::Size(74, 20);
			this->cb_COMs->TabIndex = 2;
			// 
			// tb_Log
			// 
			this->tb_Log->Location = System::Drawing::Point(101, 178);
			this->tb_Log->Multiline = true;
			this->tb_Log->Name = L"tb_Log";
			this->tb_Log->ScrollBars = System::Windows::Forms::ScrollBars::Both;
			this->tb_Log->Size = System::Drawing::Size(322, 115);
			this->tb_Log->TabIndex = 3;
			// 
			// tb_Key
			// 
			this->tb_Key->Location = System::Drawing::Point(263, 138);
			this->tb_Key->Name = L"tb_Key";
			this->tb_Key->Size = System::Drawing::Size(160, 19);
			this->tb_Key->TabIndex = 4;
			this->tb_Key->KeyDown += gcnew System::Windows::Forms::KeyEventHandler(this, &MyForm::tb_Key_KeyDown);
			this->tb_Key->KeyUp += gcnew System::Windows::Forms::KeyEventHandler(this, &MyForm::tb_Key_KeyUp);
			// 
			// tm_Pad
			// 
			this->tm_Pad->Interval = 6;
			this->tm_Pad->Tick += gcnew System::EventHandler(this, &MyForm::tm_Key_Tick);
			// 
			// label1
			// 
			this->label1->AutoSize = true;
			this->label1->Location = System::Drawing::Point(99, 15);
			this->label1->Name = L"label1";
			this->label1->Size = System::Drawing::Size(164, 12);
			this->label1->TabIndex = 5;
			this->label1->Text = L"ROMをドラッグ&&ドロップしてください";
			// 
			// label2
			// 
			this->label2->AutoSize = true;
			this->label2->Location = System::Drawing::Point(261, 121);
			this->label2->Name = L"label2";
			this->label2->Size = System::Drawing::Size(53, 12);
			this->label2->TabIndex = 6;
			this->label2->Text = L"Key input";
			// 
			// label3
			// 
			this->label3->AutoSize = true;
			this->label3->Location = System::Drawing::Point(12, 15);
			this->label3->Name = L"label3";
			this->label3->Size = System::Drawing::Size(55, 12);
			this->label3->TabIndex = 7;
			this->label3->Text = L"SerialPort";
			// 
			// label4
			// 
			this->label4->AutoSize = true;
			this->label4->Location = System::Drawing::Point(99, 61);
			this->label4->Name = L"label4";
			this->label4->Size = System::Drawing::Size(56, 12);
			this->label4->TabIndex = 8;
			this->label4->Text = L"Save data";
			// 
			// tb_SaveFileName
			// 
			this->tb_SaveFileName->AllowDrop = true;
			this->tb_SaveFileName->Location = System::Drawing::Point(101, 76);
			this->tb_SaveFileName->Name = L"tb_SaveFileName";
			this->tb_SaveFileName->Size = System::Drawing::Size(322, 19);
			this->tb_SaveFileName->TabIndex = 9;
			this->tb_SaveFileName->DragDrop += gcnew System::Windows::Forms::DragEventHandler(this, &MyForm::tb_SaveFileName_DragDrop);
			this->tb_SaveFileName->DragEnter += gcnew System::Windows::Forms::DragEventHandler(this, &MyForm::tb_SaveFileName_DragEnter);
			// 
			// MyForm
			// 
			this->AutoScaleDimensions = System::Drawing::SizeF(6, 12);
			this->AutoScaleMode = System::Windows::Forms::AutoScaleMode::Font;
			this->ClientSize = System::Drawing::Size(435, 305);
			this->Controls->Add(this->tb_SaveFileName);
			this->Controls->Add(this->label4);
			this->Controls->Add(this->label3);
			this->Controls->Add(this->label2);
			this->Controls->Add(this->label1);
			this->Controls->Add(this->tb_Key);
			this->Controls->Add(this->tb_Log);
			this->Controls->Add(this->cb_COMs);
			this->Controls->Add(this->tb_RomFileName);
			this->Controls->Add(this->btn_Send);
			this->FormBorderStyle = System::Windows::Forms::FormBorderStyle::FixedSingle;
			this->Name = L"MyForm";
			this->Text = L"SNES UARTclr";
			this->FormClosing += gcnew System::Windows::Forms::FormClosingEventHandler(this, &MyForm::MyForm_FormClosing);
			this->Load += gcnew System::EventHandler(this, &MyForm::MyForm_Load);
			this->ResumeLayout(false);
			this->PerformLayout();

		}
#pragma endregion

	private: System::Void MyForm_Load(System::Object^ sender, System::EventArgs^ e) {
		// COMポートの一覧を取得してコンボボックスに追加
		array<String^>^ ports = SerialPort::GetPortNames();
		for each (String ^ port in ports) {
			cb_COMs->Items->Add(port);
		}
		// コンボボックスの最後のアイテムを選択状態にする
		if (cb_COMs->Items->Count > 0) {
			cb_COMs->SelectedIndex = cb_COMs->Items->Count - 1;
		}
		
		// 前回のファイル名を読み込む
		String^ lastRomFileName = ConfigurationManager::AppSettings["LastRomFileName"];
		if (!String::IsNullOrEmpty(lastRomFileName)) {
			tb_RomFileName->Text = lastRomFileName;
		}
		String^ lastSaveFileName = ConfigurationManager::AppSettings["LastSaveFileName"];
		if (!String::IsNullOrEmpty(lastSaveFileName)) {
			tb_SaveFileName->Text = lastSaveFileName;
		}
	}

	private: System::Void MyForm_FormClosing(System::Object^ sender, System::Windows::Forms::FormClosingEventArgs^ e) {
		// フォーム終了時にファイル名を保存する
		String^ RomFileName = tb_RomFileName->Text;
		if (!String::IsNullOrEmpty(RomFileName)) {
			System::Configuration::Configuration^ config = ConfigurationManager::OpenExeConfiguration(ConfigurationUserLevel::None);
			config->AppSettings->Settings->Remove("LastRomFileName");
			config->AppSettings->Settings->Add("LastRomFileName", RomFileName);
			config->AppSettings->Settings->Remove("LastSaveFileName");
			config->AppSettings->Settings->Add("LastSaveFileName", tb_SaveFileName->Text);
			config->Save(ConfigurationSaveMode::Modified);
			ConfigurationManager::RefreshSection("appSettings");
		}
	}

	private: System::Void tb_RomFileName_DragEnter(System::Object^ sender, System::Windows::Forms::DragEventArgs^ e) {
		if (e->Data->GetDataPresent(DataFormats::FileDrop)) {
			e->Effect = DragDropEffects::Copy;
		}
		else {
			e->Effect = DragDropEffects::None;
		}
	}

	private: System::Void tb_RomFileName_DragDrop(System::Object^ sender, System::Windows::Forms::DragEventArgs^ e) {
		array<String^>^ files = safe_cast<array<String^>^>(e->Data->GetData(DataFormats::FileDrop));
		tb_RomFileName->Text = files[0];
	}

	private: System::Void tb_SaveFileName_DragEnter(System::Object^ sender, System::Windows::Forms::DragEventArgs^ e) {
		if (e->Data->GetDataPresent(DataFormats::FileDrop)) {
			e->Effect = DragDropEffects::Copy;
		}
		else {
			e->Effect = DragDropEffects::None;
		}
	}

	private: System::Void tb_SaveFileName_DragDrop(System::Object^ sender, System::Windows::Forms::DragEventArgs^ e) {
		array<String^>^ files = safe_cast<array<String^>^>(e->Data->GetData(DataFormats::FileDrop));
		tb_SaveFileName->Text = files[0];
	}

	private: System::Void btn_Send_Click(System::Object^ sender, System::EventArgs^ e) {

		// キータイマー停止
		tm_Pad->Stop();

		if (serialPort->IsOpen) serialPort->Close();

		if (String::IsNullOrEmpty(tb_RomFileName->Text)) {
			tb_Log->Text += "ファイルをドラッグ&ドロップしてください." + Environment::NewLine;
			return;
		}

		array<Byte>^ rom_buffer;
		array<Byte>^ save_buffer;

		try{
			String^ fileName = tb_RomFileName->Text;
			FileInfo^ fileInfo = gcnew FileInfo(fileName);
			rom_buffer = gcnew array<Byte>((long)fileInfo->Length);

			FileStream^ fileStream = gcnew FileStream(fileName, FileMode::Open, FileAccess::Read);
			BinaryReader^ reader = gcnew BinaryReader(fileStream);
			reader->Read(rom_buffer, 0, rom_buffer->Length);
			reader->Close();
			fileStream->Close();
		}
		catch (IOException^ ex) {
			tb_Log->Text += "ファイルを開くことができません." + Environment::NewLine;
			return;
		}
		/*
		{
			unsigned char sum = 0;
			for (int i = 0; i < rom_buffer->Length; i++) {
				sum += rom_buffer[i];
			}
			tb_Log->Text += "send sum: 0x" + sum.ToString("X2") + Environment::NewLine;
		}
		*/

		String^ selectedPort = cb_COMs->SelectedItem->ToString();

		btn_Send->Enabled = false;

		// シリアルポートを開く
		serialPort->PortName = selectedPort;
	//	serialPort->BaudRate = 115200; // ok
	//	serialPort->BaudRate = 230400; // ok
	//	serialPort->BaudRate = 460800; // ok
	//	serialPort->BaudRate = 691200;
	//	serialPort->BaudRate = 921600; // ok
	//	serialPort->BaudRate = 1843200; // UARTの微調整が必要
	//	serialPort->BaudRate = 2000000; // 送信ok 受信ダメ
		serialPort->BaudRate = 3000000; // 送信ok 受信ダメ
	//	serialPort->BaudRate = 2764800; // 設定NG
	//	serialPort->BaudRate = 3686400; // 設定NG
	//	serialPort->BaudRate = 4000000; // 設定NG
	//	serialPort->BaudRate = 5000000; // 設定NG
		serialPort->Parity = Parity::None;
		serialPort->DataBits = 8;
		serialPort->StopBits = StopBits::One;
		serialPort->Handshake = Handshake::None;
		try {
			serialPort->Open();

			if (tb_RomFileName->Text->EndsWith(".spc", StringComparison::OrdinalIgnoreCase)) {
				array<Byte>^ begin_buf = gcnew array<Byte> {'S', 0, 0};
				serialPort->Write(begin_buf, 0, 2);
				
				serialPort->Write(rom_buffer, 0, 256 + 65536 + 128);

				array<Byte>^ end_buf = gcnew array<Byte> { 0 };
				serialPort->Write(end_buf, 0, 1);
			}
			else { // ROM + Save
				array<Byte>^ begin_buf = gcnew array<Byte> {'R', 0, 0, 0};
				begin_buf[1] = rom_buffer->Length;
				begin_buf[2] = rom_buffer->Length >> 8;
				begin_buf[3] = rom_buffer->Length >> 16;
				serialPort->Write(begin_buf, 0, 4);
				
				serialPort->Write(rom_buffer, 0, rom_buffer->Length);

				try {
					if (String::IsNullOrEmpty(tb_SaveFileName->Text)) throw gcnew IOException("セーブファイルが指定されていません");
					String^ fileName = tb_SaveFileName->Text;
					FileInfo^ fileInfo = gcnew FileInfo(fileName);
					save_buffer = gcnew array<Byte>((long)fileInfo->Length);
					FileStream^ fileStream = gcnew FileStream(fileName, FileMode::Open, FileAccess::Read);
					BinaryReader^ reader = gcnew BinaryReader(fileStream);
					reader->Read(save_buffer, 0, save_buffer->Length);
					reader->Close();
					fileStream->Close();
					begin_buf[1] = save_buffer->Length;
					begin_buf[2] = save_buffer->Length >> 8;
					begin_buf[3] = save_buffer->Length >> 16;
					serialPort->Write(begin_buf, 1, 3);
					serialPort->Write(save_buffer, 0, save_buffer->Length);
				}
				catch (IOException^ ex) { // セーブファイルを開けない
					begin_buf[0] = 0;
					begin_buf[1] = 0;
					begin_buf[2] = 0;
					begin_buf[3] = 0;
					serialPort->Write(begin_buf, 0, 4);
				}

				array<Byte>^ end_buf = gcnew array<Byte> { 0 };
				serialPort->Write(end_buf, 0, 1);
			}
		}
		catch (UnauthorizedAccessException^ ex) {
			MessageBox::Show("シリアルポートへのアクセスが拒否されました: " + ex->Message, "エラー", MessageBoxButtons::OK, MessageBoxIcon::Error);
			btn_Send->Enabled = true;
			return;
		}
		catch (IOException^ ex) {
			MessageBox::Show("シリアルポートの操作中にエラーが発生しました: " + ex->Message, "エラー", MessageBoxButtons::OK, MessageBoxIcon::Error);
			btn_Send->Enabled = true;
			return;
		}
		catch (InvalidOperationException^ ex) {
			MessageBox::Show("シリアルポートの状態が無効です: " + ex->Message, "エラー", MessageBoxButtons::OK, MessageBoxIcon::Error);
			btn_Send->Enabled = true;
			return;
		}
		catch (Exception^ ex) {
			MessageBox::Show("シリアルポートの操作中に予期しないエラーが発生しました: " + ex->Message, "エラー", MessageBoxButtons::OK, MessageBoxIcon::Error);
			btn_Send->Enabled = true;
			return;
		}

		tb_Log->Text += "Send ok." + Environment::NewLine;

		if (tb_RomFileName->Text->EndsWith(".spc", StringComparison::OrdinalIgnoreCase)) {
			serialPort->Close();
		}
		else{ // ROM
			// フォーカスをtb_Keyに移動
			tb_Key->Focus();
			tb_Key->Clear();

			pad_data = 0;
			// キータイマー開始
			tm_Pad->Start();
		}

		btn_Send->Enabled = true;
	}

	private: System::Void tb_Key_KeyDown(System::Object^ sender, System::Windows::Forms::KeyEventArgs^ e) {
		switch (e->KeyCode) {
		case Keys::D: // A
			pad_data |= 1 << 7;
			break;
		case Keys::W: // B
			pad_data |= 1 << 15;
			break;
		case Keys::E: // X
			pad_data |= 1 << 6;
			break;
		case Keys::S: // Y
			pad_data |= 1 << 14;
			break;
		case Keys::R: // L
			pad_data |= 1 << 5;
			break;
		case Keys::T: // R
			pad_data |= 1 << 4;
			break;
		case Keys::Z: // Select
			pad_data |= 1 << 13;
			break;
		case Keys::X: // Start
			pad_data |= 1 << 12;
			break;
		case Keys::Up:
			pad_data |= 1 << 11;
			break;
		case Keys::Down:
			pad_data |= 1 << 10;
			break;
		case Keys::Left:
			pad_data |= 1 << 9;
			break;
		case Keys::Right:
			pad_data |= 1 << 8;
			break;
		}
	}

	private: System::Void tb_Key_KeyUp(System::Object^ sender, System::Windows::Forms::KeyEventArgs^ e) {
		switch (e->KeyCode) {
		case Keys::D: // A
			pad_data &= ~(1 << 7);
			break;
		case Keys::W: // B
			pad_data &= ~(1 << 15);
			break;
		case Keys::E: // X
			pad_data &= ~(1 << 6);
			break;
		case Keys::S: // Y
			pad_data &= ~(1 << 14);
			break;
		case Keys::R: // L
			pad_data &= ~(1 << 5);
			break;
		case Keys::T: // R
			pad_data &= ~(1 << 4);
			break;
		case Keys::Z: // Select
			pad_data &= ~(1 << 13);
			break;
		case Keys::X: // Start
			pad_data &= ~(1 << 12);
			break;
		case Keys::Up:
			pad_data &= ~(1 << 11);
			break;
		case Keys::Down:
			pad_data &= ~(1 << 10);
			break;
		case Keys::Left:
			pad_data &= ~(1 << 9);
			break;
		case Keys::Right:
			pad_data &= ~(1 << 8);
			break;
		}
	}

	private: System::Void tm_Key_Tick(System::Object^ sender, System::EventArgs^ e) {
		if (serialPort->IsOpen) {
			array<Byte>^ padBuffer = gcnew array<Byte> { 'P', 0, 0 };
			padBuffer[1] = pad_data >> 4;
			padBuffer[2] = pad_data >> 12;
			serialPort->Write(padBuffer, 0, padBuffer->Length);
		}
	}

};
}
