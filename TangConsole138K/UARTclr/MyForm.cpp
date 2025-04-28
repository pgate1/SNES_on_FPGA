#include "MyForm.h"

//using namespace System;
//using namespace System::Windows::Forms;
using namespace UARTclr;

[STAThreadAttribute]
int __stdcall WinMain()
{
    MyForm^ form = gcnew MyForm();
    form->ShowDialog();
    return 0;
}
