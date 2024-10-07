
Процедура Печать(ТабДок, Ссылка) Экспорт
	//{{_КОНСТРУКТОР_ПЕЧАТИ(Печать)
	Макет = Справочники.ФункциональныеШК.ПолучитьМакет("Печать");
	Запрос = Новый Запрос;
	Запрос.Текст =
	"ВЫБРАТЬ
	|	ФункциональныеШК.Код,
	|	ФункциональныеШК.Наименование
	|ИЗ
	|	Справочник.ФункциональныеШК КАК ФункциональныеШК
	|ГДЕ
	|	ФункциональныеШК.Ссылка В (&Ссылка)";
	Запрос.Параметры.Вставить("Ссылка", Ссылка);
	Выборка = Запрос.Выполнить().Выбрать();

	ОбластьЗаголовок = Макет.ПолучитьОбласть("Заголовок");
	Область = Макет.ПолучитьОбласть("Шапка");
	Шапка = Макет.ПолучитьОбласть("Шапка");
	ТабДок.Очистить();

	ВставлятьРазделительСтраниц = Ложь;
	Пока Выборка.Следующий() Цикл
		ОбластьШК=Область.Области.Шапка;
		РисунокШтрихкод=Область.Рисунки.РисунокШтрихкод;

		Если ВставлятьРазделительСтраниц Тогда
			ТабДок.ВывестиГоризонтальныйРазделительСтраниц();
		КонецЕсли;
		РисунокШтрихкод.Картинка = ПоказатьШК(Формат(9900000000000+Число(Выборка.Код),"ЧГ=0"));
		РисунокШтрихкод.Расположить(ОбластьШК);

		Область.Параметры.Заполнить(Выборка);
		ТабДок.Вывести(Область, Выборка.Уровень());

		ВставлятьРазделительСтраниц = Истина;
	КонецЦикла;
	//}}
КонецПроцедуры
Функция  ПоказатьШК(ШК)
	ВнешняяКомпонента = Обработки.ПечатьЭтикетокИЦенников.ПодключитьВнешнююКомпонентуПечатиШтрихкода(); 

	ПараметрыШтрихкода=новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина",50);
	ПараметрыШтрихкода.Вставить("Высота",30);
	ПараметрыШтрихкода.Вставить("ТипКода",1);
	ПараметрыШтрихкода.Вставить("ОтображатьТекст",истина);
	ПараметрыШтрихкода.Вставить("РазмерШрифта",12);
	ПараметрыШтрихкода.Вставить("Штрихкод","123456789101");
	
	ПараметрыШтрихкода.Штрихкод=ШК;
	РисунокШтрихкод = Обработки.ПечатьЭтикетокИЦенников.ПолучитьКартинкуШтрихкода(ВнешняяКомпонента, ПараметрыШтрихкода);
	//РисунокШтрихкод.Расположить(ОбластьШК);
	Возврат РисунокШтрихкод;	
КонецФункции
