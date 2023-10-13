# Generated by Django 3.0.4 on 2020-10-05 08:33

from django.db import migrations, models


class Migration(migrations.Migration):

    dependencies = [
        ('rbac', '0003_auto_20201002_2003'),
    ]

    operations = [
        migrations.AddField(
            model_name='dormitory',
            name='day',
            field=models.CharField(default='00', max_length=6, verbose_name='日'),
        ),
        migrations.AddField(
            model_name='dormitory',
            name='month',
            field=models.CharField(default='00', max_length=6, verbose_name='月'),
        ),
        migrations.AddField(
            model_name='dormitory',
            name='text',
            field=models.CharField(default='无', max_length=250, verbose_name='整改方案'),
        ),
        migrations.AddField(
            model_name='dormitory',
            name='year',
            field=models.CharField(default='0000', max_length=6, verbose_name='年'),
        ),
        migrations.AlterField(
            model_name='teacher',
            name='sclass',
            field=models.CharField(default=0, max_length=2, verbose_name='管理年级/管理楼号'),
        ),
    ]