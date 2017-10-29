# memo

https://github.com/mattn/memo
�̉��܂˂ł��B
Ruby �ł̎������~�����ď����܂����B

## �C���X�g�[��

�܂� gem �ɂ��ĂȂ��ł��B

## �g����

```
$ memo help
Commands:
  memo config [OPERATION]  # configure
  memo delete PATTERN      # delete memo
  memo edit [FILE]         # edit memo
  memo grep PATTERN        # grep memo
  memo help [COMMAND]      # Describe available commands or one specific command
  memo list [PATTERN]      # list memo
  memo new [TITLE]         # create memo
  memo serve               # start http server
```

## �v���O�C��

memo �̃v���O�C���V�X�e���͂���Ȃɕ��G�ł͂Ȃ��c�͂��ł��B

�v���O�C���̖��O�́Aa-zA-Z �Ŏn�܂� a-zA-Z0-9 �ő���������A
�܂�v���O���~���O����̎��ʎq�݂����ȕ�������A
�_�b�V�����邢�̓n�C�t���ŘA���������́A�ɂȂ�܂��B

�����āA memo/plugins/xxx �Ƃ����p�X�� require �����
Ruby ���C�u�������A xxx �Ƃ������O�̃v���O�C������������
���ƂƂ��܂��B

����ɁA���̃v���O�C���� gem �ŃC���X�g�[������ꍇ�A
memo-plugin-xxx �Ƃ������O�ł���K�v������܂��B

�v���O�C���̎����� Memo::Plugin �N���X���p�������N���X��
�΂��čs���A���̃N���X���� Memo::Plugins::Xxx �ł���
�K�v������܂��B Xxx �́A�v���O�C�������A�_�b�V�����邢��
�n�C�t������؂�Ƃ��ĕ������A�L���s�^���C�Y���A�A����������
���O�ɂȂ�܂��B

 * ��: some-plug �Ƃ��� memo �v���O�C��
 * gem: memo-plugin-some-plug
 * /lib/memo/plugins/some-plug.rb ����
        require 'memo/plugin'

        module Memo
          module Plugins
            class SomePlug < Plugin
              # ...
            end
          end
        end

����Ƃ��Ă� memo �̕W���R�}���h�݂͂�ȃv���O�C���Ŏ��������
���܂��̂ŁA lib/memo/plugins/ �ȉ������Ă݂Ă��������B


## ���C�Z���X

LICENSE �����Ă��������B MIT ���C�Z���X�ł��B

## �A��

arikui.ruby _at_ gmail.com

