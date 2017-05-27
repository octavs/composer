(cat > composer.sh; chmod +x composer.sh; exec bash composer.sh)
#!/bin/bash
set -ev

# Get the current directory.
DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Get the full path to this script.
SOURCE="${DIR}/composer.sh"

# Create a work directory for extracting files into.
WORKDIR="$(pwd)/composer-data"
rm -rf "${WORKDIR}" && mkdir -p "${WORKDIR}"
cd "${WORKDIR}"

# Find the PAYLOAD: marker in this script.
PAYLOAD_LINE=$(grep -a -n '^PAYLOAD:$' "${SOURCE}" | cut -d ':' -f 1)
echo PAYLOAD_LINE=${PAYLOAD_LINE}

# Find and extract the payload in this script.
PAYLOAD_START=$((PAYLOAD_LINE + 1))
echo PAYLOAD_START=${PAYLOAD_START}
tail -n +${PAYLOAD_START} "${SOURCE}" | tar -xzf -

# Pull the latest Docker images from Docker Hub.
docker-compose pull
docker pull hyperledger/fabric-ccenv:x86_64-1.0.0-alpha

# Kill and remove any running Docker containers.
docker-compose -p composer kill
docker-compose -p composer down --remove-orphans

# Kill any other Docker containers.
docker ps -aq | xargs docker rm -f

# Start all Docker containers.
docker-compose -p composer up -d

# Wait for the Docker containers to start and initialize.
sleep 10

# Create the channel on peer0.
docker exec peer0 peer channel create -o orderer0:7050 -c mychannel -f /etc/hyperledger/configtx/mychannel.tx

# Join peer0 to the channel.
docker exec peer0 peer channel join -b mychannel.block

# Fetch the channel block on peer1.
docker exec peer1 peer channel fetch -o orderer0:7050 -c mychannel

# Join peer1 to the channel.
docker exec peer1 peer channel join -b mychannel.block

# Open the playground in a web browser.
case "$(uname)" in 
"Darwin") open http://localhost:8080
          ;;
"Linux")  if [ -n "$BROWSER" ] ; then
	       	        $BROWSER http://localhost:8080
	        elif    which xdg-open > /dev/null ; then
	                xdg-open http://localhost:8080
          elif  	which gnome-open > /dev/null ; then
	                gnome-open http://localhost:8080
          #elif other types blah blah
	        else   
    	            echo "Could not detect web browser to use - please launch Composer Playground URL using your chosen browser ie: <browser executable name> http://localhost:8080 or set your BROWSER variable to the browser launcher in your PATH"
	        fi
          ;;
*)        echo "Playground not launched - this OS is currently not supported "
          ;;
esac

# Exit; this is required as the payload immediately follows.
exit 0
PAYLOAD:
� 5�)Y �]Ys�:�g�
j^��xߺ��F���6�`��R�ٌ���c Ig�tB:��[���1HB�u��	7�'��ʍ��4��|
�4M�(M"�w���(��A ��1�R#?�9����vZ�}Y��v��\��(�G�O|?�������4^f2".�?E�d%�2��oS�_�C��_�,��w���叒8]ɿ\(����⊽u4\.��9�%���}��S���p��I��*���k��O'^���r�I�8
�"�;y?��{4-��Z���w�O�x��r���C�1�Fhsp�<��)�r	�i�)�!	�\�(!�i�d0�v<�tQ�	�&���W��(C���O/��D���&�Ԑ2:���WGpbCVk"/�A���&0�Z[�Ny��ty���,#�.��&���[�j��Z��P6m-hS���Zv�)�� n����W�،���@O+16)=�;�|<7�}��QQ��:�=��񔥇��VB�F��� �f�OX�z_^Ⱥ,R�B�#[�����ڷoЩ��*��wG�����o{�t������������_)�(��e\?^'~����������+�_
�^�Y��Bm�j~Y����\�@(k�R�Y��2C�gͥ�m-��0\M�nO�0�BE�r��,�Դ�����A4��F �<��5L���x�Fdb�P�S�S�&mdq���!9�G��9����'��6̅;g�ヸ��B��b�Mn1�zn���A�!⊠���z�ŌG�!i�^=ܧ� v0?�`����Сs͡��Չ�XD���Cq'������Y�M��I[,��oā�q�t1�S�b>��Cso୥bpc�S��L� O
�>
p�����yxsh���H"S�n$L�^�[\c�ƨ��s��/;hS@�N��䒡ʅ�ʻ�R�L�ŭ�L�f�E�F�S q|~O�E�5�(�dz�>h���@���{p+O<��p `��Q�:��xY���"cR��M����� ��z`m:�������}�\)L�B�<@B��^�x�:tr �	>��-�F\Ę�2�`���>;��ߵs9䖓�%���D�b�ՇL�@�"=�cш�̢O�Q��>,>0����{f��_���4|����Q���R�A����x��ѧ���R�x���Y��Nt��:PC��f{��W�d�%��'�s>��v<�3�H'B�~Ĩ�*�#F};��rd��A��`� �EZ��`����4E�w���7��0EWrH<�0��'�5�%��;�b��V.�S^S�Q���lM�HM\L���C�f�ߛe�.�i���ռ���ž�@h]�.?���gN�ȅ�D�=�5af[8�ȑ�[���9k@@H\^d��!��
 y;?U2�x-�cb��a�59p�k9�;�u]�����f�ڔ�Q"��0~:h=��E�Fѥ>��6s0!����8N�H�YD��M��_��~a(�v�7�6cyb|�M����u-�WS�ͬ��C��db<�?�/��~����?$Q�����Ϝ�/�����t��e���+�����\{����c/���#D*�/�$�ό���RP��T�?�>�I���D1�(�-�N�S$[�w���@X$�q��\֡0�\�P��Y������e����G�?NU�_� ��o���~�Ѥ���#��u�u<K�s�G ��e�?�����-ض�`FL�9i��e�l)�z�"��Ɨs�3ܠ��Ȃ�`�͍9�Z�+���u�`5J�`�Y��4��ދ_����S�������������/��_��W��U������S�)� �?J������+o�����o�Px$t�0�7[� -x�������]>tl�0�ެ���31��B���d�{*��< }d�ex�I&��T�[ӹg�6|�=̝�*"��"	s=����z���dް��1�?M�B�x��	����NV�;�g���5�H��q9#�����@~���-�A�%�S�q�s ��l(bK Ӑ���s'������m�2	\X�7h�y��磅iϞ�P���I`*����;����C���b��v�in��:K{��,�;�!/7;��
�(!�D��|$s�"yY��	���@N�b�Ak����S���������2�!�������KA��W����������k�����E���K�%���_��������T�_���.���(��@�"�����%��16���ӏ:��O8C������빁���(���H��>��,IRv�����_���Z�e���?�	�"�Z�T��csbkL�6��s�U�����Г��b�J }'��N�VRjhH�(�Nb{��W#�D�Q�[��nno��P�' �!H�g�A+z�d�~8�����fU�߻�x�ǩ�~���?J��9x���'���w��P�����B�߾�L)\.����_
�+���o_V�˟�1���H����b���j�o)��0}����������F���g1"`1Ǳm�el��P��%X�=,�h��]�� g	&�f�G����P��/_�)ސ��O�`�����x�����	���m,� �r�+�5�D�|����j@.�l�uw�9��+>��z*�F��Qc&�:e^3�Z������p�i�a��3���}m�`�`f���ϻ�����������J��`��$���������'��ٗFU(e����P�O㿋���J�k�_�c���?��s Vrt��_c	K ��o����>��gI ���1v?n���AUZ.�wAU��72���A�o>�a=:�;���@C��~شs�ā�ɧ>;�S�żx��ж�1���t�o�0��"F�E7Ӭ����	5��D�Xo�Ql�f:Gm᭸h.)�74L��(g=�@�p[�G1��#�Gz�I��9|��I,̹���p�wk�ʹ�Q�hMX���UjS����ҝJ���9�[a��5� �RgD��ކ��t�w��n7�5���`��Ԝ��]]q��B[��n;i�圳�xJX9[��1�C�y��L;AO�%�����ӻ�����E�/��4����>R�����?�U�)�-�
����	�3��[��%ʐ�������JT翗������������k���;��4r�����>|�ǽ��O��|�o �my�>��} �{ܖ�^��}�4��r�?9zp Dbl'�����>���$���ld�l�k��e+=5%���ʱkiBÐNe3&ɜ��ep*7<��k����q�W��k�A@O�x�ygs���l��f��9r5��Z�lޥ�ݴo���<k$���Ž������Z�-Xr�\���������i4l����BEا���<{�)>R��t���?BU�_)�-��Y�G���$|�����9(C��Y�?��ge�>���j��Z����ߨ��u
���?vDe������uw1�cBV񟥠����+��s���X�����?�ￕ�������1%Q�q(�%\���"��� p���G	�X�
p�G(��������
e����G翐T��S
.����)�rrط̩�f�/0DhN=���l��y�-Z����?� ��q[iXW��E��5��ľ����UQRs̡��+8��)L�Z:Yg�Q�&���F}���ش������ݹ��?J�̿�G������?Z����(R��W)��iVh������ (�������P�����R�M#;���&��O��1��t�^���C�P�z�\#W�"�ا����4����\�+�ծj�t����M����`��?����?=}1��u����I|=���V��^z_k٤v���zZG�(�u��H�>�VӅ_{��O�C���q�h��/��NΫ]9������$��v坺`/6������KNu��֧����ڞ.��fiGŨp훻ʠ����p;r���}eX��hluuA�E��!��:7�o�*]���!ק/�>^�r_�fW�v��kE%��|��^�q������\;�BϾ��.:J�'ߺ�/^--���DYrg��X����}�u��Y�E���K�2iA���^ܛ������Ӻ8�?��n���6��5x���ߟWe���?��ǒ����4����NM��t>]�7�4�Z��d�qb�'p��p8]O6�u��~0�I�^�=L|�	�!�#%pVϧ�� }T�#����Gdq�S7�X=��^��2)���7|�*��q$�C4dE��o��y\VGƷu��'�J1g�^WV�o��t���I��᭝��f	�-����D?}�'㶘���q��ۻ�X��:����\�J��.c����K�u/*�u��u[��)��t]��[{ڽԄ�`�K��I����D?h�/�%�A�!Fb�~@�n��ζsv�b���ӵ��O����￿�y�b��y0����M���i��������lt1<�d�$3�X�R2��q�ږ�c��'�k ��0�/����n�LˁiVFǢK��0н@4�׀�}2��lnr(aƅ|��yGU�$����C��m��hNԍ��+��Ah�ef�tðJ�@������8X�1�Ȓ�mE�uS�F�ޱJ�3v��qf�zxN�CI���3��dG:��B��LS�n9���^��U�#��!���q����8sq\��CS1��ȬJ�?P��-��oֈ�9|r��xiȘuTx�oU�K��nݜ�E��Y���Ma��M��4�"G�ӥ�l8���hpꛃS�N��N''F~0��|D��uru�N�_T$v �r�UY���`.�u���=�9��jL]�X�A-���,�n"I��,�T�>��V�?d9N�.[<g�tJ��a�yߌ�.#J#����_3�F?�+�ѽ^�ԚbTaFw��A�Y]}(�����%w���:L�Y)c�?fH�z��g �+V����Es��E�R$yP`k�lͼ�����r�������W?���޾���Q%�ق�p:�Xa��ι �g��{p�!���O�,�9����ҭ#2d�c�ǚ����.#&h����Lc<�M��N��ڹt|��w��j�2�]]��dC�ע��.�h�B��k�sˮ�܁�S��^UM���٧<4�7�":�Wv������,l���������5�������������^���@a��Ʃ�����ϯv^k�ą������DO6�"�^�_��Q7��ey4�z=۾jե�
���x8?�y8��3zx�N�;t���kw���?\��Z�|��C�)~���]z�ϟ�^��3حt�	
��\3�C?tB��	�n\z�΍�W�Ϝ��}z�����<���M���M�{��Ma��H֧�y����#rދ�\��r=����F/aL�5�	���xa��B�`h��o3�QX��7, �|��6rDr3o��X��;��%����������2\��4�S�{��Ks�|���z�&��a�2�|=8���fn1/$>g�ۜl�,�I"�6:��s���*�a����t��v����d��"Y��no͢ʤ����il����LH���V��{�o��\�r��bB�3p)(��BB�*��L�l>��^JM)p�뭗B���~�>��S6�f��L�U����"�v�@Xj_�Om�#���'8$�f����bX{j���[�[��kJ6�ƃ��VqW<�$��6�.s����8��+�(Dsy��V�'�ܑPR̄�l��'$ q8d%�a�I#�r
fZp$B�H��Z>�!���1��9d�;�M����V!�Jj���v�V,�#�?�4Y��y�ZJ�Q�\����a�����`��N��\��w�C>?�D��F��W��1)˒Xg�e˝��u�@�Kq��R2��D���L~( �j�@�~�kE��`�n�H�_	��X1��T��D[i�"T�����MNYpF��ZQ�"t�����i��3-)5�,{�gd�*KT��!_���}C�к|�nX9��0vu"Q9�	Ǜ��#����bλU�~p	�T2R�#�&S��
դ�K�}�����*Kl���(Ke���,Q4��
��*\%I��B����Bg�5s����4Ϸ��P�jW�Eyk'�N+�*op;�;�Ĥ� r�}8e	�ɚDp/��2Hz#LʕΔ9�S�=�3�K��	m�ޡ�{[�Z��BI`�7�ҽ��� XB�y�	7�C��[ �ِ���kM�kR��)�=C1�M�l9�nO��i0�)����l����V��6N�F�Os����Zk�}:�v%��A���'֮�8]7�*me��tr買O�Y��L�Y�r��4�VU��]� ��D#�.w�Ѝ�5�j����,���B���A)Y�q�&�Fp�q���%itr�Np1�)�y���̯�6U���~�oi-;Pxh:Nj�$["Np�ٚLm�C7C�����?��}�a�u�N�s�Bg֮�����	K��!hP �T��-�n��ׅ���TyV�Y2��2�������4�(z_�*|�<�2dV�H?�<���-N�U��9�� ���H�����1����!��8�������m}�<���~)X�������Ik�A�EJ=S�b� ȷ��-�Vvn�A���ԑiK�E��Ѡa.:J�p�����,88q4�Q��
���t��"�{����H��p�CS�R�R�_$����(X��]�	�#�--���V����� �y�DP��#[L)��u�6Y��W�Ջ�`��=�*�F�`�@P��)0ZLP��	
i�?���4n�=jb8D,K�$S��CD��x&:����z+1�h��#�F��`�/���;��"]��+CoKAEg���8W�^�|�|cs�hC���T/&[��ER��GP]�6�� LR��r8+70}\�i�^:�����6�8l�8��u�zIwC��N�-S��i�;&�9&>ӊ9˳��C�u*���i+î�;��zX���������}Y<,;������:�d��#l��$�rW�$�c^v��)�����,fPy���8V��3A�IL5(2iE��5eY���0�pyg0aԦ��Ĕ�CdP#����Ʃ-W a�;J��)1-�(L ��%�FH�ܞ.��ax0���p���*&����`��X8l0d7B��yd�]"5����Q�wP��䐨+Q��W���y���bYl�#�����^)U���,���e��F�0�"teK.��w��aMLlI8�st�%y�\/�"�N7��j�)컴���m�q��ǡ��l�o%��}h�l&�
���Br+��6.�[Ͱ]�m�QVk-!�V;\����µ���)��qD�TT^�xM���3|^K�<X�K��߂؄ h��Dq��w���z��8��$�y��N@WXn�E`1�^}�on�^�����^z������������5�aͮ�=|��nv�M'�s�?Q���?|����,	87�>���<Hw_z�������oz��7���'������'����Sq�8��[׮4�~�W&W�t��FӉjh:�F��W~�c�|��;���8=�x�7���=	�N��(���)j�N��Yj�6�Ӧv��N�&`�lj������H�i��iS;mj����>����yh��e�^8�r��%���,4�6y�m!t�����o=fb褏���!��<��5�E���n��3�?�ڟRm��m�q�g<�#p$���d��zmj��2O˞3cG[�93�� {Z�=g�6�8.Ü�#��=���13��q��Z[����G���y\�R�����v����d��m�/�C��  