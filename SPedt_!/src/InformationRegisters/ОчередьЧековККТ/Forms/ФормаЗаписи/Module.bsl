#Область ОбработчикиСобытийФормы

&НаСервере
Процедура ПриСозданииНаСервере(Отказ, СтандартнаяОбработка)
	
	Если Параметры.Свойство("АвтоТест") Тогда // Возврат при получении формы для анализа.
		Возврат;
	КонецЕсли;
	
	Реквизиты = МенеджерОборудованияВызовСервера.ДанныеЧекаВОчереди(Запись.ИдентификаторЗаписи);
	Если Реквизиты <> Неопределено Тогда
		Текст = МенеджерОборудованияКлиентСервер.СформироватьТекстНефискальногоДокумента(0, Реквизиты.ДанныеЧека, 42);
		QRКодЧекаККТ = Неопределено;
		Если Реквизиты.СтатусЧека = Перечисления.СтатусЧекаККТВОчереди.Фискализирован Тогда
			ФискальнаяОперации = МенеджерОборудованияВызовСервера.ДанныеФискальнойОперации(Реквизиты.ДокументОснование, Реквизиты.ИдентификаторЗаписи);
			Если ФискальнаяОперации <> Неопределено Тогда
				ПараметрыQRКода = МенеджерОборудованияКлиентСервер.ПараметрыQRКодаЧекаККТ();
				ПараметрыQRКода.ДатаВремяРасчета = ФискальнаяОперации.Дата;
				ПараметрыQRКода.СуммаРасчета = ФискальнаяОперации.Сумма;
				ПараметрыQRКода.НомерФискальногоНакопителя = ФискальнаяОперации.ЗаводскойНомерФН;
				ПараметрыQRКода.НомерФискальногоДокумента = ФискальнаяОперации.НомерЧекаККМ;
				ПараметрыQRКода.ФискальныйПризнак = ФискальнаяОперации.ФискальныйПризнак;
				ПараметрыQRКода.ПризнакРасчета = ФискальнаяОперации.ТипРасчета;
				QRКодЧека = МенеджерОборудованияКлиентСервер.СформироватьQRКодЧекаККТ(ПараметрыQRКода);
			КонецЕсли;
		КонецЕсли;
		СформироватьНаСервере(Текст, QRКодЧека);
	КонецЕсли;
	
	Элементы.ТекстОшибки.Видимость = Запись.СтатусЧека = Перечисления.СтатусЧекаККТВОчереди.Ошибка;
	
КонецПроцедуры

#КонецОбласти 

&НаСервере
Функция ПолучитьШтрихкод(ШиринаШтрихкода, ВысотаШтрихкода, Штрихкод)
	
	ПараметрыШтрихкода = Новый Структура;
	ПараметрыШтрихкода.Вставить("Ширина"            , ШиринаШтрихкода);
	ПараметрыШтрихкода.Вставить("Высота"            , ВысотаШтрихкода);
	ПараметрыШтрихкода.Вставить("ТипКода"           , 16);
	ПараметрыШтрихкода.Вставить("ОтображатьТекст"   , Истина);
	ПараметрыШтрихкода.Вставить("РазмерШрифта"      , 12);
	ПараметрыШтрихкода.Вставить("УголПоворота"      , 0);
	ПараметрыШтрихкода.Вставить("Штрихкод"          , Штрихкод);
	ПараметрыШтрихкода.Вставить("ПрозрачныйФон"     , Ложь);
	ПараметрыШтрихкода.Вставить("Масштабировать"    , Ложь);
	Возврат МенеджерОборудованияВызовСервера.ПолучитьКартинкуШтрихкода(ПараметрыШтрихкода);
	
КонецФункции

&НаСервере
Процедура СформироватьНаСервере(Текст, QRКодЧека)
	
	QRКод.Очистить();
	
	Макет = РегистрыСведений.ОчередьЧековККТ.ПолучитьМакет("Макет");
	Область = Макет.ПолучитьОбласть("Строка|Колонка");
	Рисунок = Область.Рисунки.ШтрихКод;
	
	ОбластьТекст = Макет.ПолучитьОбласть("Текст");
	ОбластьТекст.Область("Текст").Текст = Текст;
	QRКод.Вывести(ОбластьТекст);
	
	Если QRКодЧека <> Неопределено Тогда
		Эталон = Справочники.ПодключаемоеОборудование.ПолучитьМакет("МакетДляОпределенияКоэффициентовЕдиницИзмерения");
		КоличествоМиллиметровВПикселеВысота = Эталон.Рисунки.Квадрат100Пикселей.Высота / 100;
		КоличествоМиллиметровВПикселеШирина = Эталон.Рисунки.Квадрат100Пикселей.Ширина / 100;
		ШиринаШтрихкода = Окр(Рисунок.Ширина / КоличествоМиллиметровВПикселеШирина);
		ВысотаШтрихкода = Окр(Рисунок.Высота / КоличествоМиллиметровВПикселеВысота);
		Картинка = ПолучитьШтрихкод(ШиринаШтрихкода, ВысотаШтрихкода, QRКодЧека);
		Рисунок.Картинка = Картинка;
		QRКод.Вывести(Область);
	КонецЕсли;
	
КонецПроцедуры
