

Функция  ПоказатьШК()
	ВнешняяКомпонента = Обработки.ПечатьЭтикетокИЦенников.ПодключитьВнешнююКомпонентуПечатиШтрихкода(); 

	ПараметрыШтрихкода=новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина",50);
	ПараметрыШтрихкода.Вставить("Высота",30);
	ПараметрыШтрихкода.Вставить("ТипКода",1);
	ПараметрыШтрихкода.Вставить("ОтображатьТекст",истина);
	ПараметрыШтрихкода.Вставить("РазмерШрифта",12);
	ПараметрыШтрихкода.Вставить("Штрихкод","123456789101");
	
	ПараметрыШтрихкода.Штрихкод=Объект.Код;
	РисунокШтрихкод = Обработки.ПечатьЭтикетокИЦенников.ПолучитьКартинкуШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода);
	//РисунокШтрихкод.Расположить(ОбластьШК);
	Возврат РисунокШтрихкод;	
КонецФункции	

&НаКлиенте
Процедура штрихкодПриИзменении(Элемент)
	Элементы.КартинкаШК.Картинка=ПоказатьШК();
КонецПроцедуры
